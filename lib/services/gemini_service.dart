import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:deep_scan/models/ingredient.dart';

import 'package:deep_scan/models/product.dart';
import 'package:deep_scan/models/recipe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';

final apiKey = dotenv.env['API_KEY'] ?? 'API key not found';

class GeminiService {
  final GenerativeModel _model;
  late ChatSession chat;

  //constructor
  GeminiService()
      : _model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: apiKey,
        );

  Future<Product?> imageScan(List<XFile> images, String prompt) async {
    try {
      final List<Future<(Uint8List, String)>> imageProcessing =
          images.map((img) async {
        final bytes = await img.readAsBytes();
        final mimeType = await getImageMimeType(img);
        return (bytes, mimeType);
      }).toList();

      final processedImages = await Future.wait(imageProcessing);

      final imageParts = processedImages
          .map(
            (img) => DataPart(img.$2, img.$1),
          )
          .toList();

      //start the chat send the images.
      chat = _model.startChat(history: [
        Content.multi([...imageParts])
      ]);

      final initialPrompt = Content.text(prompt);
      var response = await chat.sendMessage(initialPrompt);

      if (response.text == null) {
        throw Exception('No response from Gemini API');
      }

      // Attempt to parse the response as JSON
      try {
        var uuid = const Uuid();
        String uuidString = uuid.v4();
        final data = jsonDecode(response.text!) as Map<String, dynamic>;
        data['id'] = uuidString;
        if (data['product_is_related'] == false) {
          return null;
        }

        final product = Product.fromJson(data);
        return product;
      } catch (e) {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> getIngredientDeepAnalysis(String prompt) async {
    try {
      final ingredientDeepAnalysisPrompt = Content.text(prompt);
      var response = await chat.sendMessage(ingredientDeepAnalysisPrompt);

      if (response.text == null) {
        throw Exception('No response from Gemini API');
      }

      try {
        final data = response.text!;
        return data;
      } catch (e) {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> getEcoDeepAnalysis(String prompt) async {
    try {
      final ecoDeepAnalysisPrompt = Content.text(prompt);
      var response = await chat.sendMessage(ecoDeepAnalysisPrompt);

      if (response.text == null) {
        throw Exception('No response from Gemini API');
      }

      try {
        final data = response.text!;
        return data;
      } catch (e) {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> getNutrients(String prompt) async {
    try {
      final nutrientsPrompt = Content.text(prompt);
      var response = await chat.sendMessage(nutrientsPrompt);

      if (response.text == null) {
        throw Exception('No response from Gemini API');
      }

      try {
        final data = response.text!;
        return data;
      } catch (e) {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> howToUse(String prompt) async {
    try {
      final howToUsePrompt = Content.text(prompt);
      var response = await chat.sendMessage(howToUsePrompt);

      if (response.text == null) {
        throw Exception('No response from Gemini API');
      }

      try {
        final data = response.text!;
        return data;
      } catch (e) {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Future<String?> findProduct(String prompt) async {
  //   try {
  //     final findProduct = Content.text(prompt);
  //     var response = await chat.sendMessage(findProduct);

  //     if (response.text == null) {
  //       throw Exception('No response from Gemini API');
  //     }

  //     try {
  //       final data = response.text!;
  //       return data;
  //     } catch (e) {
  //       return null;
  //     }
  //   } catch (e) {
  //     return null;
  //   }
  // }

  Future<List<Ingredient>?> getIngredients(String prompt) async {
    try {
      final ingredientPrompt = Content.text(prompt);
      var response = await chat.sendMessage(ingredientPrompt);

      if (response.text == null) {
        throw Exception('No response from Gemini API');
      }

      // Attempt to parse the response as JSON
      try {
        final data = jsonDecode(response.text!);

        final ingredients = data['ingredients'];

        List<Ingredient> ingredientsList = [];

        ingredients.forEach((ingredient) {
          final ing = Ingredient.fromJson(ingredient);
          ingredientsList.add(ing);
        });

        return ingredientsList;
      } catch (e) {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<Recipe?> getHomeMadeRecipe(String prompt) async {
    try {
      final recipePrompt = Content.text(prompt);
      var response = await chat.sendMessage(recipePrompt);

      if (response.text == null) {
        throw Exception('No response from Gemini API');
      }

      // Attempt to parse the response as JSON
      try {
        Map<String, dynamic> jsonMap = json.decode(response.text!);

        Recipe recipe = Recipe.fromJson(jsonMap);

        return recipe;
      } catch (e) {
        print(e);
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> getImageMimeType(XFile file) async {
    // First, check the file extension
    String extension = path.extension(file.path).toLowerCase();
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.bmp':
        return 'image/bmp';
      case '.webp':
        return 'image/webp';
      default:
        // If the extension is not recognized, we'll check the file signature
        return _checkFileSignature(await file.readAsBytes());
    }
  }

  String _checkFileSignature(Uint8List bytes) {
    if (bytes.length < 4) return 'application/octet-stream';

    final signature = bytes.sublist(0, 4);

    if (listEquals(signature, [0xFF, 0xD8, 0xFF, 0xE0]) ||
        listEquals(signature, [0xFF, 0xD8, 0xFF, 0xE1])) {
      return 'image/jpeg';
    } else if (listEquals(signature, [0x89, 0x50, 0x4E, 0x47])) {
      return 'image/png';
    } else if (listEquals(signature, [0x47, 0x49, 0x46, 0x38])) {
      return 'image/gif';
    } else if (listEquals(signature.sublist(0, 2), [0x42, 0x4D])) {
      return 'image/bmp';
    } else if (listEquals(signature, [0x52, 0x49, 0x46, 0x46])) {
      // WEBP files start with "RIFF" signature, but we need to check further
      if (bytes.length >= 12 &&
          listEquals(bytes.sublist(8, 12), [0x57, 0x45, 0x42, 0x50])) {
        return 'image/webp';
      }
    }

    return 'application/octet-stream'; // Default to binary data if unknown
  }
}
