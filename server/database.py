"""
MongoDB database connection and initialization
"""
from pymongo import MongoClient
from pymongo.errors import ConnectionFailure, ServerSelectionTimeoutError
from config import Config
import logging

logger = logging.getLogger(__name__)

# Global database connection
_client = None
_db = None

def get_database():
    """Get MongoDB database instance"""
    global _db
    if _db is None:
        connect_to_database()
    return _db

def connect_to_database():
    """Connect to MongoDB database"""
    global _client, _db
    
    try:
        # Create MongoDB client
        _client = MongoClient(
            Config.MONGODB_URI,
            serverSelectionTimeoutMS=5000,  # 5 second timeout
            connectTimeoutMS=5000
        )
        
        # Test connection
        _client.admin.command('ping')
        
        # Get database
        _db = _client[Config.DATABASE_NAME]
        
        logger.info(f"Successfully connected to MongoDB: {Config.DATABASE_NAME}")
        
        # Create indexes for better query performance
        create_indexes()
        
        return _db
        
    except (ConnectionFailure, ServerSelectionTimeoutError) as e:
        logger.error(f"Failed to connect to MongoDB: {e}")
        raise
    except Exception as e:
        logger.error(f"Unexpected error connecting to MongoDB: {e}")
        raise

def create_indexes():
    """Create database indexes for better query performance"""
    global _db
    
    if _db is None:
        return
    
    try:
        # Users collection indexes
        _db.users.create_index("userId", unique=True)
        _db.users.create_index("email", unique=True, sparse=True)
        
        # Posts collection indexes
        _db.posts.create_index("id", unique=True)
        _db.posts.create_index("authorId")
        _db.posts.create_index("timestamp")
        _db.posts.create_index([("timestamp", -1)])  # Descending for recent posts
        
        # Comments collection indexes
        _db.comments.create_index("postId")
        _db.comments.create_index("timestamp")
        
        # Activities collection indexes
        _db.activities.create_index("userId")
        _db.activities.create_index("date")
        _db.activities.create_index([("date", -1)])
        
        # Chat messages collection indexes
        _db.chat_messages.create_index("chatId")
        _db.chat_messages.create_index("timestamp")
        
        # Crop health history indexes
        _db.crop_health.create_index("userId")
        _db.crop_health.create_index("timestamp")
        
        logger.info("Database indexes created successfully")
        
    except Exception as e:
        logger.warning(f"Error creating indexes: {e}")

def close_connection():
    """Close MongoDB connection"""
    global _client
    if _client:
        _client.close()
        logger.info("MongoDB connection closed")

def check_connection():
    """Check if database connection is alive"""
    global _client, _db
    try:
        if _client is None or _db is None:
            return False
        _client.admin.command('ping')
        return True
    except:
        return False

