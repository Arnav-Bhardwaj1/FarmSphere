# Plant Disease Recognition Server

A lightweight Python Flask server for plant disease detection using TensorFlow Lite.

## Setup

1. **Install Python dependencies:**
   ```bash
   cd server
   pip install -r requirements.txt
   ```

2. **Place the model file:**
   - Download the `plant_disease_recog_model_pwp.tflite` file
   - Place it in `assets/model.tflite`

3. **Start the server:**
   ```bash
   python plant_disease_api.py
   ```

   The server will start on `http://localhost:5000`

## API Endpoints

### GET /health
Check if the server is running.

**Response:**
```json
{
  "status": "ok",
  "model_loaded": true
}
```

### POST /predict
Predict plant disease from an image.

**Request:**
- Content-Type: `multipart/form-data`
- Field: `file` (image file)

**Response:**
```json
{
  "results": [
    {
      "label": "Tomato___Early_blight",
      "confidence": 0.95
    },
    {
      "label": "Tomato___healthy",
      "confidence": 0.03
    }
  ]
}
```

## Notes

- The model supports 38 plant disease classes
- Minimum confidence threshold: 0.1 (10%)
- Returns top 3 predictions
- Image preprocessing: resize to 224x224, normalize to 0-1

