"""
API routes for FarmSphere backend
"""
from flask import Blueprint, request, jsonify
from datetime import datetime
from bson import ObjectId
from database import get_database
from models import (
    User, Post, Comment, Activity, ChatMessage, 
    CropHealth, PostLike, SavedPost
)
import logging

logger = logging.getLogger(__name__)

# Create Blueprint
api = Blueprint('api', __name__, url_prefix='/api')

# Helper function to convert ObjectId to string
def serialize_doc(doc):
    """Convert MongoDB document to JSON-serializable format"""
    if doc is None:
        return None
    if isinstance(doc, dict):
        result = {}
        for key, value in doc.items():
            if isinstance(value, ObjectId):
                result[key] = str(value)
            elif isinstance(value, datetime):
                result[key] = value.isoformat()
            elif isinstance(value, dict):
                result[key] = serialize_doc(value)
            elif isinstance(value, list):
                result[key] = [serialize_doc(item) for item in value]
            else:
                result[key] = value
        return result
    return doc

# ==================== USER ROUTES ====================

@api.route('/users', methods=['POST'])
def create_user():
    """Create a new user"""
    try:
        data = request.json
        db = get_database()
        
        user_id = data.get('userId') or str(datetime.now().timestamp())
        user_doc = User.create_user(
            user_id=user_id,
            name=data.get('name', ''),
            email=data.get('email', ''),
            phone=data.get('phone', ''),
            location=data.get('location', '')
        )
        
        # Check if user already exists
        existing = db.users.find_one({'userId': user_id})
        if existing:
            return jsonify(serialize_doc(existing)), 200
        
        db.users.insert_one(user_doc)
        return jsonify(serialize_doc(user_doc)), 201
        
    except Exception as e:
        logger.error(f"Error creating user: {e}")
        return jsonify({'error': str(e)}), 500

@api.route('/users/<user_id>', methods=['GET'])
def get_user(user_id):
    """Get user by ID"""
    try:
        db = get_database()
        user = db.users.find_one({'userId': user_id})
        
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        return jsonify(serialize_doc(user)), 200
        
    except Exception as e:
        logger.error(f"Error getting user: {e}")
        return jsonify({'error': str(e)}), 500

# ==================== POST ROUTES ====================

@api.route('/posts', methods=['GET'])
def get_posts():
    """Get all posts (with pagination)"""
    try:
        db = get_database()
        page = int(request.args.get('page', 1))
        limit = int(request.args.get('limit', 20))
        skip = (page - 1) * limit
        
        posts = list(db.posts.find().sort('timestamp', -1).skip(skip).limit(limit))
        total = db.posts.count_documents({})
        
        return jsonify({
            'posts': [serialize_doc(post) for post in posts],
            'total': total,
            'page': page,
            'limit': limit
        }), 200
        
    except Exception as e:
        logger.error(f"Error getting posts: {e}")
        return jsonify({'error': str(e)}), 500

@api.route('/posts', methods=['POST'])
def create_post():
    """Create a new post"""
    try:
        data = request.json
        db = get_database()
        
        post_id = data.get('id') or str(datetime.now().timestamp())
        post_doc = Post.create_post(
            post_id=post_id,
            author_id=data.get('authorId', ''),
            author_name=data.get('author', ''),
            content=data.get('content', ''),
            location=data.get('location', ''),
            tags=data.get('tags', []),
            image=data.get('image')
        )
        
        db.posts.insert_one(post_doc)
        return jsonify(serialize_doc(post_doc)), 201
        
    except Exception as e:
        logger.error(f"Error creating post: {e}")
        return jsonify({'error': str(e)}), 500

@api.route('/posts/<post_id>', methods=['GET'])
def get_post(post_id):
    """Get a specific post"""
    try:
        db = get_database()
        post = db.posts.find_one({'id': post_id})
        
        if not post:
            return jsonify({'error': 'Post not found'}), 404
        
        return jsonify(serialize_doc(post)), 200
        
    except Exception as e:
        logger.error(f"Error getting post: {e}")
        return jsonify({'error': str(e)}), 500

@api.route('/posts/<post_id>', methods=['DELETE'])
def delete_post(post_id):
    """Delete a post"""
    try:
        db = get_database()
        result = db.posts.delete_one({'id': post_id})
        
        if result.deleted_count == 0:
            return jsonify({'error': 'Post not found'}), 404
        
        # Also delete related comments and likes
        db.comments.delete_many({'postId': post_id})
        db.post_likes.delete_many({'postId': post_id})
        db.saved_posts.delete_many({'postId': post_id})
        
        return jsonify({'message': 'Post deleted successfully'}), 200
        
    except Exception as e:
        logger.error(f"Error deleting post: {e}")
        return jsonify({'error': str(e)}), 500

# ==================== COMMENT ROUTES ====================

@api.route('/posts/<post_id>/comments', methods=['GET'])
def get_comments(post_id):
    """Get comments for a post"""
    try:
        db = get_database()
        comments = list(db.comments.find({'postId': post_id}).sort('timestamp', 1))
        
        return jsonify({
            'comments': [serialize_doc(comment) for comment in comments]
        }), 200
        
    except Exception as e:
        logger.error(f"Error getting comments: {e}")
        return jsonify({'error': str(e)}), 500

@api.route('/posts/<post_id>/comments', methods=['POST'])
def create_comment(post_id):
    """Create a comment on a post"""
    try:
        data = request.json
        db = get_database()
        
        # Check if post exists
        post = db.posts.find_one({'id': post_id})
        if not post:
            return jsonify({'error': 'Post not found'}), 404
        
        comment_id = data.get('id') or str(datetime.now().timestamp())
        comment_doc = Comment.create_comment(
            comment_id=comment_id,
            post_id=post_id,
            user_id=data.get('userId', ''),
            user_name=data.get('userName', 'User'),
            content=data.get('content', '')
        )
        
        db.comments.insert_one(comment_doc)
        
        # Update post comment count
        db.posts.update_one(
            {'id': post_id},
            {'$inc': {'comments': 1}, '$set': {'updatedAt': datetime.utcnow()}}
        )
        
        return jsonify(serialize_doc(comment_doc)), 201
        
    except Exception as e:
        logger.error(f"Error creating comment: {e}")
        return jsonify({'error': str(e)}), 500

# ==================== LIKE ROUTES ====================

@api.route('/posts/<post_id>/like', methods=['POST'])
def toggle_like(post_id):
    """Toggle like on a post"""
    try:
        data = request.json
        user_id = data.get('userId', '')
        
        if not user_id:
            return jsonify({'error': 'userId is required'}), 400
        
        db = get_database()
        
        # Check if post exists
        post = db.posts.find_one({'id': post_id})
        if not post:
            return jsonify({'error': 'Post not found'}), 404
        
        # Check if already liked
        existing_like = db.post_likes.find_one({'postId': post_id, 'userId': user_id})
        
        if existing_like:
            # Unlike
            db.post_likes.delete_one({'postId': post_id, 'userId': user_id})
            db.posts.update_one(
                {'id': post_id},
                {'$inc': {'likes': -1}, '$set': {'updatedAt': datetime.utcnow()}}
            )
            return jsonify({'liked': False, 'likes': post.get('likes', 0) - 1}), 200
        else:
            # Like
            like_doc = PostLike.create_like(post_id, user_id)
            db.post_likes.insert_one(like_doc)
            db.posts.update_one(
                {'id': post_id},
                {'$inc': {'likes': 1}, '$set': {'updatedAt': datetime.utcnow()}}
            )
            return jsonify({'liked': True, 'likes': post.get('likes', 0) + 1}), 200
        
    except Exception as e:
        logger.error(f"Error toggling like: {e}")
        return jsonify({'error': str(e)}), 500

@api.route('/posts/<post_id>/likes', methods=['GET'])
def get_post_likes(post_id):
    """Get users who liked a post"""
    try:
        db = get_database()
        likes = list(db.post_likes.find({'postId': post_id}))
        
        return jsonify({
            'likes': [serialize_doc(like) for like in likes]
        }), 200
        
    except Exception as e:
        logger.error(f"Error getting likes: {e}")
        return jsonify({'error': str(e)}), 500

# ==================== SAVE POST ROUTES ====================

@api.route('/posts/<post_id>/save', methods=['POST'])
def toggle_save(post_id):
    """Toggle save on a post"""
    try:
        data = request.json
        user_id = data.get('userId', '')
        
        if not user_id:
            return jsonify({'error': 'userId is required'}), 400
        
        db = get_database()
        
        # Check if post exists
        post = db.posts.find_one({'id': post_id})
        if not post:
            return jsonify({'error': 'Post not found'}), 404
        
        # Check if already saved
        existing_save = db.saved_posts.find_one({'postId': post_id, 'userId': user_id})
        
        if existing_save:
            # Unsave
            db.saved_posts.delete_one({'postId': post_id, 'userId': user_id})
            return jsonify({'saved': False}), 200
        else:
            # Save
            saved_doc = SavedPost.create_saved_post(post_id, user_id)
            db.saved_posts.insert_one(saved_doc)
            return jsonify({'saved': True}), 200
        
    except Exception as e:
        logger.error(f"Error toggling save: {e}")
        return jsonify({'error': str(e)}), 500

@api.route('/users/<user_id>/saved-posts', methods=['GET'])
def get_saved_posts(user_id):
    """Get saved posts for a user"""
    try:
        db = get_database()
        saved_posts = list(db.saved_posts.find({'userId': user_id}).sort('createdAt', -1))
        
        # Get full post details
        post_ids = [sp['postId'] for sp in saved_posts]
        posts = list(db.posts.find({'id': {'$in': post_ids}}))
        
        return jsonify({
            'posts': [serialize_doc(post) for post in posts]
        }), 200
        
    except Exception as e:
        logger.error(f"Error getting saved posts: {e}")
        return jsonify({'error': str(e)}), 500

# ==================== ACTIVITY ROUTES ====================

@api.route('/users/<user_id>/activities', methods=['GET'])
def get_activities(user_id):
    """Get activities for a user"""
    try:
        db = get_database()
        page = int(request.args.get('page', 1))
        limit = int(request.args.get('limit', 20))
        skip = (page - 1) * limit
        
        activities = list(
            db.activities.find({'userId': user_id})
            .sort('timestamp', -1)
            .skip(skip)
            .limit(limit)
        )
        
        return jsonify({
            'activities': [serialize_doc(activity) for activity in activities]
        }), 200
        
    except Exception as e:
        logger.error(f"Error getting activities: {e}")
        return jsonify({'error': str(e)}), 500

@api.route('/users/<user_id>/activities', methods=['POST'])
def create_activity(user_id):
    """Create a new activity"""
    try:
        data = request.json
        db = get_database()
        
        activity_id = data.get('id') or str(datetime.now().timestamp())
        activity_doc = Activity.create_activity(
            activity_id=activity_id,
            user_id=user_id,
            activity_type=data.get('type', ''),
            crop=data.get('crop', ''),
            notes=data.get('notes', '')
        )
        
        db.activities.insert_one(activity_doc)
        return jsonify(serialize_doc(activity_doc)), 201
        
    except Exception as e:
        logger.error(f"Error creating activity: {e}")
        return jsonify({'error': str(e)}), 500

# ==================== CHAT ROUTES ====================

@api.route('/chats/<chat_id>/messages', methods=['GET'])
def get_chat_messages(chat_id):
    """Get messages for a chat"""
    try:
        db = get_database()
        page = int(request.args.get('page', 1))
        limit = int(request.args.get('limit', 50))
        skip = (page - 1) * limit
        
        messages = list(
            db.chat_messages.find({'chatId': chat_id})
            .sort('timestamp', 1)
            .skip(skip)
            .limit(limit)
        )
        
        return jsonify({
            'messages': [serialize_doc(message) for message in messages]
        }), 200
        
    except Exception as e:
        logger.error(f"Error getting chat messages: {e}")
        return jsonify({'error': str(e)}), 500

@api.route('/chats/<chat_id>/messages', methods=['POST'])
def create_chat_message(chat_id):
    """Create a chat message"""
    try:
        data = request.json
        db = get_database()
        
        message_id = data.get('id') or str(datetime.now().timestamp())
        message_doc = ChatMessage.create_message(
            message_id=message_id,
            chat_id=chat_id,
            user_id=data.get('userId', ''),
            user_name=data.get('userName', 'User'),
            content=data.get('content', '')
        )
        
        db.chat_messages.insert_one(message_doc)
        return jsonify(serialize_doc(message_doc)), 201
        
    except Exception as e:
        logger.error(f"Error creating chat message: {e}")
        return jsonify({'error': str(e)}), 500

# ==================== CROP HEALTH ROUTES ====================

@api.route('/users/<user_id>/crop-health', methods=['GET'])
def get_crop_health_history(user_id):
    """Get crop health diagnosis history for a user"""
    try:
        db = get_database()
        page = int(request.args.get('page', 1))
        limit = int(request.args.get('limit', 20))
        skip = (page - 1) * limit
        
        diagnoses = list(
            db.crop_health.find({'userId': user_id})
            .sort('timestamp', -1)
            .skip(skip)
            .limit(limit)
        )
        
        return jsonify({
            'diagnoses': [serialize_doc(diagnosis) for diagnosis in diagnoses]
        }), 200
        
    except Exception as e:
        logger.error(f"Error getting crop health history: {e}")
        return jsonify({'error': str(e)}), 500

@api.route('/users/<user_id>/crop-health', methods=['POST'])
def create_crop_health_diagnosis(user_id):
    """Save a crop health diagnosis"""
    try:
        data = request.json
        db = get_database()
        
        diagnosis_id = data.get('id') or str(datetime.now().timestamp())
        diagnosis_doc = CropHealth.create_diagnosis(
            diagnosis_id=diagnosis_id,
            user_id=user_id,
            image_url=data.get('imageUrl'),
            results=data.get('results', []),
            location=data.get('location')
        )
        
        db.crop_health.insert_one(diagnosis_doc)
        return jsonify(serialize_doc(diagnosis_doc)), 201
        
    except Exception as e:
        logger.error(f"Error creating crop health diagnosis: {e}")
        return jsonify({'error': str(e)}), 500

