// import 'package:flutter/material.dart';
// import 'package:flutter_tflite/flutter_tflite.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';




// // Function to pick an image and classify
// Future<void> pickImage() async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile? image = await _picker.pickImage(source: ImageSource.camera);

//     if (image != null) {
//       classifyImage(image.path);
//     }
//   }

//   // Function to load the TFLite model
//   Future<void> loadModel() async {
//     await Tflite.loadModel(
//       model: "assets/model.tflite",
//       labels: "assets/labels.txt",
//     );
//   }

//   // Function to classify the picked image
//   Future<void> classifyImage(String imagePath) async {
//     await loadModel();
//     var recognitions = await Tflite.runModelOnImage(
//       path: imagePath,
//       imageMean: 127.5,
//       imageStd: 127.5,
//       numResults: 5,
//       threshold: 0.5,
//     );

//     if (recognitions != null) {
//       for (var recognition in recognitions) {
//         print('Food: ${recognition['label']} with confidence: ${recognition['confidence']}');
//       }
//     }
//   }

//   // Widget to build the list of food items
//   Widget _buildFoodList(BuildContext context) {
//     final dietProvider = Provider.of<DietProvider>(context);
//     final foodList = dietProvider.getFoodList();

//     if (foodList.isEmpty) {
//       return Center(child: Text('No food intake recorded.'));
//     }

//     return ListView.builder(
//       itemCount: foodList.length,
//       itemBuilder: (context, index) {
//         final Food food = foodList[index];
//         return ListTile(
//           title: Text(food.name),
//           subtitle: Text('Calories: ${food.calories}'),
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('${food.dateTime}'),
//               IconButton(
//                 icon: Icon(Icons.delete, color: Colors.red),
//                 onPressed: () {
//                   dietProvider.removeFood(index);  // Remove the food at the current index
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }