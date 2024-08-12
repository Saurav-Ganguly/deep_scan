import 'package:flutter/material.dart';
import 'package:deep_scan/services/gemini_service.dart';
import 'package:deep_scan/services/speech_service.dart';

class ChatService {
  final GeminiService _geminiService;
  final SpeechService _speechService;
  final String productName;

  ChatService(this._geminiService, this._speechService, this.productName);

  Future<String> getUserInput(BuildContext context,
      {required Function(String) onSpeechResult}) async {
    return await _speechService.getUserInput(context,
        onSpeechResult: onSpeechResult);
  }

  Future<String> processUserQuery(String query) async {
    try {
      String response =
          await _geminiService.chatAboutProduct(query, productName);
      return response;
    } catch (e) {
      print("Error processing query: $e");
      return "I'm sorry, I encountered an error while processing your query. Could you please try again?";
    }
  }

  Future<void> speakResponse(String response) async {
    if (_speechService.isSpeechAvailable) {
      await _speechService.speak(response);
    }
  }

  bool get isSpeechAvailable => _speechService.isSpeechAvailable;

  Future<void> initializeSpeech() async {
    await _speechService.initializeSpeech();
  }

  Future<void> stopResponse() async {
    await _speechService.stopSpeaking();
  }
}
