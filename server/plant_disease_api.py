"""
Plant Disease Recognition API Server
A lightweight Flask server for hosting the TensorFlow model and MongoDB backend
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
import tensorflow as tf
import numpy as np
from PIL import Image
import io
import base64
import os
import logging

# Import MongoDB modules
from config import Config
from database import connect_to_database, check_connection, close_connection
from api_routes import api as api_blueprint

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)
app.config.from_object(Config)
CORS(app)

# Register API blueprint
app.register_blueprint(api_blueprint)

# Global variables
model = None
class_names = []

def load_model():
    """Load the TensorFlow Keras model"""
    global model, class_names
    
    try:
        # Load the Keras model from project root
        model_path = os.path.join(os.path.dirname(__file__), '..', 'plant_disease_recog_model_pwp.keras')
        
        if not os.path.exists(model_path):
            print(f"Model not found at: {model_path}")
            # Try alternative path
            model_path = os.path.join(os.path.dirname(__file__), 'plant_disease_recog_model_pwp.keras')
        
        if not os.path.exists(model_path):
            print(f"Model not found at: {model_path}")
            raise FileNotFoundError(f"Model file not found at {model_path}")
        
        # Load the Keras model
        model = tf.keras.models.load_model(model_path)
        print(f"Model loaded successfully from: {model_path}")
        
        # Print model info
        print(f"Model input shape: {model.input_shape}")
        print(f"Model output shape: {model.output_shape}")
        print(f"Model input layers: {[layer.name for layer in model.inputs]}")
        
        # Load class names from the JSON file
        import json
        # Prefer project root `plant_disease.json`, fall back to legacy folder location
        server_dir = os.path.dirname(__file__)
        candidates = [
            os.path.join(server_dir, '..', 'plant_disease.json'),
            os.path.join(server_dir, '..', 'Plant-Disease-Recognition-System-main', 'plant_disease.json'),
            os.path.join(server_dir, 'plant_disease.json'),
        ]
        json_path = None
        for path in candidates:
            if os.path.exists(path):
                json_path = path
                break
        if json_path is None:
            raise FileNotFoundError("plant_disease.json not found in expected locations")
        with open(json_path, 'r') as f:
            class_data = json.load(f)
            class_names = [item['name'] for item in class_data]
        print(f"Loaded class metadata from: {os.path.abspath(json_path)}")
        
        print(f"Classes loaded: {len(class_names)}")
        print(f"First 5 classes: {class_names[:5]}")
        
    except Exception as e:
        print(f"Error loading model: {e}")
        import traceback
        traceback.print_exc()

def preprocess_image(image_bytes):
    """Preprocess image using EfficientNet preprocessing"""
    # Load image from bytes using PIL
    image = Image.open(io.BytesIO(image_bytes))
    
    # Resize to match model input
    image = image.resize((160, 160))
    
    # Convert to RGB if necessary
    if image.mode != 'RGB':
        image = image.convert('RGB')
    
    # Convert to numpy array
    img_array = np.array(image).astype(np.float32)
    
    # Use EfficientNet's preprocessing function
    # This normalizes images to [-1, 1] range
    img_array = tf.keras.applications.efficientnet.preprocess_input(img_array)
    
    # Add batch dimension
    img_array = np.expand_dims(img_array, axis=0)
    
    return img_array

@app.route('/predict', methods=['POST'])
def predict():
    """Handle prediction requests"""
    global model
    
    if model is None:
        return jsonify({'error': 'Model not loaded'}), 500
    
    try:
        # Get image from request
        if 'file' in request.files:
            file = request.files['file']
            image_bytes = file.read()
        elif 'image' in request.json:
            # Base64 encoded image
            image_data = request.json['image']
            image_bytes = base64.b64decode(image_data)
        else:
            return jsonify({'error': 'No image provided'}), 400
        
        # Preprocess image
        processed_image = preprocess_image(image_bytes)
        
        # Run inference with Keras model
        predictions = model.predict(processed_image, verbose=0)[0]
        
        # Apply softmax to convert logits to probabilities if needed
        # Some models output raw logits, some output probabilities already
        if predictions.min() < 0 or predictions.max() > 1:
            # Convert from logits to probabilities using softmax
            from scipy.special import softmax
            predictions = softmax(predictions)
        
        print(f"Predictions shape: {predictions.shape}")
        print(f"Top 5 indices: {np.argsort(predictions)[-5:][::-1]}")
        print(f"Top 5 values: {predictions[np.argsort(predictions)[-5:][::-1]]}")
        
        # Get top 3 predictions (sorted by confidence)
        top_indices = np.argsort(predictions)[-3:][::-1]
        
        results = []
        for idx in top_indices:
            confidence = float(predictions[idx])
            if confidence > 0.1:  # Only include if confidence > 10%
                results.append({
                    'label': class_names[idx],
                    'confidence': confidence
                })
                print(f"Class: {class_names[idx]}, Index: {idx}, Confidence: {confidence:.4f}")
        
        return jsonify({'results': results})
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint"""
    db_status = check_connection()
    return jsonify({
        'status': 'ok', 
        'model_loaded': model is not None,
        'database_connected': db_status
    })

@app.route('/api/health', methods=['GET'])
def api_health():
    """API health check endpoint"""
    db_status = check_connection()
    return jsonify({
        'status': 'ok',
        'database_connected': db_status
    })

if __name__ == '__main__':
    try:
        # Connect to MongoDB
        logger.info("Connecting to MongoDB...")
        connect_to_database()
        logger.info("MongoDB connected successfully")
    except Exception as e:
        logger.warning(f"MongoDB connection failed: {e}")
        logger.warning("Server will start without database. Some features may not work.")
    
    # Load ML model
    logger.info("Loading ML model...")
    load_model()
    
    logger.info("Starting server on http://localhost:5000")
    try:
    app.run(host='0.0.0.0', port=5000, debug=True)
    finally:
        # Close database connection on shutdown
        close_connection()

