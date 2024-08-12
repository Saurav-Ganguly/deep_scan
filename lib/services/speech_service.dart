import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _speechAvailable = false;

  Future<bool> initializeSpeech() async {
    try {
      _speechAvailable = await _speech.initialize(
        onError: (error) => print('Speech recognition error: $error'),
        debugLogging: true,
      );
      print('Speech recognition available: $_speechAvailable');
    } catch (e) {
      print('Error initializing speech recognition: $e');
      _speechAvailable = false;
    }
    return _speechAvailable;
  }

  Future<String> getUserInput(BuildContext context,
      {required Function(String) onSpeechResult}) async {
    if (_speechAvailable) {
      return await listenForSpeech(onSpeechResult: onSpeechResult);
    } else {
      return await _getTextInput(context);
    }
  }

  Future<String> listenForSpeech(
      {required Function(String) onSpeechResult}) async {
    String recognizedWords = '';
    bool finishedListening = false;

    try {
      await _speech.listen(
        onResult: (result) {
          recognizedWords = result.recognizedWords;
          onSpeechResult(recognizedWords);
          print('Recognized words: $recognizedWords');
        },
        listenFor: Duration(seconds: 30), // Increased to 30 seconds
        pauseFor: Duration(seconds: 3), // Will pause after 3 seconds of silence
        // partialResults: true,
        // onSoundLevelChange: (level) {
        //   // You can use this to provide visual feedback of speech level
        // },
        // cancelOnError: true,
        // listenMode: stt.ListenMode.confirmation,
      );

      // Wait until speech is finished
      while (!finishedListening) {
        await Future.delayed(Duration(milliseconds: 100));
        if (!_speech.isListening) {
          finishedListening = true;
        }
      }
    } catch (e) {
      print("Error during speech recognition: $e");
    } finally {
      await _speech.stop();
    }
    return recognizedWords;
  }

  Future<String> _getTextInput(BuildContext context) async {
    String? input = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String tempInput = '';
        return AlertDialog(
          title: Text('Enter your question'),
          content: TextField(
            onChanged: (value) {
              tempInput = value;
            },
            decoration: InputDecoration(hintText: "Type your question here"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop(tempInput);
              },
            ),
          ],
        );
      },
    );
    return input ?? '';
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
  }

  bool get isSpeechAvailable => _speechAvailable;
}
