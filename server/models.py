"""
Database models and schemas for FarmSphere
"""
from datetime import datetime
from typing import Optional, List, Dict, Any
from bson import ObjectId

class User:
    """User model"""
    @staticmethod
    def create_user(user_id: str, name: str, email: str, phone: str, location: str) -> Dict[str, Any]:
        """Create a new user document"""
        return {
            'userId': user_id,
            'name': name,
            'email': email,
            'phone': phone,
            'location': location,
            'createdAt': datetime.utcnow(),
            'updatedAt': datetime.utcnow(),
            'isActive': True
        }

class Post:
    """Community post model"""
    @staticmethod
    def create_post(
        post_id: str,
        author_id: str,
        author_name: str,
        content: str,
        location: str,
        tags: List[str] = None,
        image: Optional[str] = None
    ) -> Dict[str, Any]:
        """Create a new post document"""
        return {
            'id': post_id,
            'authorId': author_id,
            'author': author_name,
            'content': content,
            'location': location,
            'tags': tags or [],
            'image': image,
            'likes': 0,
            'comments': 0,
            'timestamp': datetime.utcnow(),
            'createdAt': datetime.utcnow(),
            'updatedAt': datetime.utcnow()
        }

class Comment:
    """Comment model"""
    @staticmethod
    def create_comment(
        comment_id: str,
        post_id: str,
        user_id: str,
        user_name: str,
        content: str
    ) -> Dict[str, Any]:
        """Create a new comment document"""
        return {
            'id': comment_id,
            'postId': post_id,
            'userId': user_id,
            'userName': user_name,
            'content': content,
            'timestamp': datetime.utcnow(),
            'createdAt': datetime.utcnow()
        }

class Activity:
    """Farm activity model"""
    @staticmethod
    def create_activity(
        activity_id: str,
        user_id: str,
        activity_type: str,
        crop: str,
        notes: str
    ) -> Dict[str, Any]:
        """Create a new activity document"""
        return {
            'id': activity_id,
            'userId': user_id,
            'type': activity_type,
            'crop': crop,
            'notes': notes,
            'date': datetime.utcnow(),
            'timestamp': datetime.utcnow(),
            'createdAt': datetime.utcnow()
        }

class ChatMessage:
    """Chat message model"""
    @staticmethod
    def create_message(
        message_id: str,
        chat_id: str,
        user_id: str,
        user_name: str,
        content: str
    ) -> Dict[str, Any]:
        """Create a new chat message document"""
        return {
            'id': message_id,
            'chatId': chat_id,
            'userId': user_id,
            'userName': user_name,
            'content': content,
            'timestamp': datetime.utcnow(),
            'createdAt': datetime.utcnow()
        }

class CropHealth:
    """Crop health diagnosis model"""
    @staticmethod
    def create_diagnosis(
        diagnosis_id: str,
        user_id: str,
        image_url: Optional[str],
        results: List[Dict[str, Any]],
        location: Optional[str] = None
    ) -> Dict[str, Any]:
        """Create a new crop health diagnosis document"""
        return {
            'id': diagnosis_id,
            'userId': user_id,
            'imageUrl': image_url,
            'results': results,
            'location': location,
            'timestamp': datetime.utcnow(),
            'createdAt': datetime.utcnow()
        }

class PostLike:
    """Post like model"""
    @staticmethod
    def create_like(post_id: str, user_id: str) -> Dict[str, Any]:
        """Create a new post like document"""
        return {
            'postId': post_id,
            'userId': user_id,
            'createdAt': datetime.utcnow()
        }

class SavedPost:
    """Saved post model"""
    @staticmethod
    def create_saved_post(post_id: str, user_id: str) -> Dict[str, Any]:
        """Create a new saved post document"""
        return {
            'postId': post_id,
            'userId': user_id,
            'createdAt': datetime.utcnow()
        }

