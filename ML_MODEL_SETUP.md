# ML Model Setup Guide

## Plant Disease Detection Model

The FarmSphere app uses a TensorFlow Lite model for plant disease detection. Due to GitHub's file size limits, the model file is not included in the repository.

### Getting the Model

1. **Download the model file:**
   - The model file should be named `model.tflite`
   - Place it in the `assets/` directory
   - Also place a copy in `ml_model_package/assets/` for the package

2. **Model Requirements:**
   - File format: TensorFlow Lite (.tflite)
   - Expected input: Image tensor (224x224x3)
   - Expected output: Disease classification probabilities

3. **Alternative Sources:**
   - Train your own model using TensorFlow
   - Use pre-trained models from TensorFlow Hub
   - Contact the development team for the original model

### File Structure

```
assets/
├── model.tflite          # Main model file (not in Git)
├── classes.txt           # Disease class labels
└── ...

ml_model_package/assets/
├── model.tflite          # Package model file (not in Git)
├── classes.txt           # Disease class labels
└── ...
```

### Important Notes

- The model file is **not tracked by Git** due to size limitations
- Each developer needs to obtain their own copy of the model
- The model file should be approximately 94MB in size
- Ensure the model is compatible with TensorFlow Lite runtime

### Troubleshooting

If you get errors about missing model files:
1. Verify the model file exists in both `assets/` and `ml_model_package/assets/`
2. Check that the file is named exactly `model.tflite`
3. Ensure the model file is not corrupted
4. Verify the model is compatible with your Flutter/TensorFlow Lite setup
