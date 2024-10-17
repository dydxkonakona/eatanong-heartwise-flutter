import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';




// Function to pick an image and classify
Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      classifyImage(image.path);
    }
  }

  // Function to load the TFLite model
  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    );
  }

  // Function to classify the picked image
  Future<void> classifyImage(String imagePath) async {
    await loadModel();
    var recognitions = await Tflite.runModelOnImage(
      path: imagePath,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 5,
      threshold: 0.5,
    );

    if (recognitions != null) {
      for (var recognition in recognitions) {
        print('Food: ${recognition['label']} with confidence: ${recognition['confidence']}');
      }
    }
  }
