// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:true_ingred/ingredient_analyser/img_picker_widget.dart';
// import 'package:true_ingred/prompt.dart';

// class IngredientAnalyser extends StatefulWidget {
//   const IngredientAnalyser({super.key});

//   @override
//   State<IngredientAnalyser> createState() => _IngredientAnalyserState();
// }

// class _IngredientAnalyserState extends State<IngredientAnalyser> {
//   //gemini model
//   late File _image;
//   // Access your API key as an environment variable (see "Set up your API key" above)
//   static const apiKey = 'AIzaSyCMNdIZyJQbX2TaD5fJ7mqH16CgLayL4N0';
//   final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
//   String? text;

//   void getTextData() async {
//     final content = [Content.text('Write a story about a AI and magic')];
//     final response = await model.generateContent(content);
//     setState(() {
//       text = response.text;
//     });
//   }

//   void imageScan() async {
//     final img = await _image.readAsBytes();
//     var prompt = TextPart(ingredientScan);
//     final imageParts = DataPart('image/jpeg', img);
//     final response = await model.generateContent([
//       Content.multi([prompt, imageParts])
//     ]);
//     setState(() {
//       text = response.text;
//     });
//   }

//   void _pickImage(File img) {
//     _image = img;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('TrueIngred')),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ImgPickerWidget(
//                 pickImage: _pickImage,
//               ),
//               ElevatedButton(
//                 onPressed: imageScan,
//                 child: const Text('Scan Ingredients'),
//               ),
//               Text(text ?? "Loading"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
