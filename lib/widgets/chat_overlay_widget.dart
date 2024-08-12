import 'package:flutter/material.dart';
import 'package:deep_scan/services/chat_service.dart';

class ChatOverlayWidget extends StatefulWidget {
  final ChatService chatService;
  final VoidCallback onClose;

  const ChatOverlayWidget(
      {Key? key, required this.chatService, required this.onClose})
      : super(key: key);

  @override
  _ChatOverlayWidgetState createState() => _ChatOverlayWidgetState();
}

class _ChatOverlayWidgetState extends State<ChatOverlayWidget> {
  String _currentMessage = '';
  bool _isListening = false;
  bool _isSpeaking = false;
  bool _isThinking = false;
  bool _showMicButton = false;

  @override
  void initState() {
    super.initState();
    _startInteraction();
  }

  @override
  void dispose() {
    widget.chatService.stopResponse();
    super.dispose();
  }

  void _startInteraction() async {
    setState(() {
      _currentMessage = "What would you like to know about the product?";
      _isSpeaking = true;
    });
    await widget.chatService.speakResponse(_currentMessage);
    setState(() {
      _isSpeaking = false;
      _showMicButton = true;
    });
  }

  Future<void> _startListening() async {
    setState(() {
      _isListening = true;
      _showMicButton = false;
      _currentMessage = "Listening... (Tap the mic when you're done speaking)";
    });

    String query = await widget.chatService.getUserInput(
      context,
      onSpeechResult: (String partialResult) {
        setState(() {
          _currentMessage = partialResult;
        });
      },
    );

    setState(() {
      _isListening = false;
    });

    if (query.isNotEmpty) {
      _processQuery(query);
    } else {
      setState(() {
        _currentMessage = "I didn't catch that. Please try again.";
        _showMicButton = true;
      });
    }
  }

  void _processQuery(String query) async {
    setState(() {
      _isThinking = true;
      _currentMessage = "Thinking...";
    });

    String response = await widget.chatService.processUserQuery(query);

    setState(() {
      _isThinking = false;
      _isSpeaking = true;
      _currentMessage = response;
    });

    await widget.chatService.speakResponse(response);

    setState(() {
      _isSpeaking = false;
      _showMicButton = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.onClose();
        return false;
      },
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isThinking)
                ThinkingAnimation()
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    _currentMessage,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(height: 20),
              if (_isListening)
                ListeningAnimation(onStop: _startListening)
              else if (_isSpeaking)
                SpeakingAnimation()
              else if (_showMicButton)
                MicButton(onPressed: _startListening),
            ],
          ),
        ),
      ),
    );
  }
}

class ThinkingAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Thinking...',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        SizedBox(height: 10),
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ],
    );
  }
}

class ListeningAnimation extends StatelessWidget {
  final VoidCallback onStop;

  const ListeningAnimation({Key? key, required this.onStop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onStop,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.mic, color: Colors.white, size: 48),
      ),
    );
  }
}

class SpeakingAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.volume_up, color: Colors.white, size: 48);
  }
}

class MicButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MicButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          Icons.mic,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
