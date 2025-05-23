// food_ai.dart

import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:final_eatanong_flutter/screens/results_page.dart';

class ImageClassifier {
  final BuildContext context;
  final ImagePicker _picker = ImagePicker();
  bool _isModelLoaded = false;

  ImageClassifier(this.context) {
    _loadModel();
  }

  // Load the TFLite model once
  Future<void> _loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
      );
      _isModelLoaded = true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error loading model")),
      );
    }
  }

  // Public function to initiate image picking and classification
  Future<void> classifyImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      await _classifyImage(image.path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No image selected")),
      );
    }
  }

  // Function to classify the image
  Future<void> _classifyImage(String imagePath) async {
    if (!_isModelLoaded) {
      return;
    }

    try {
      var recognitions = await Tflite.runModelOnImage(
        path: imagePath,
        imageMean: 127.5,
        imageStd: 127.5,
        numResults: 3,
        threshold: 0.000001,
      );

      if (recognitions != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsPage(recognitions: recognitions),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No recognitions found")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error during classification")),
      );
    }
  }

  // Function to clean up resources
  void dispose() {
    Tflite.close();
  }
}
