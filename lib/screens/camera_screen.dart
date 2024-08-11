import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io';

import 'package:deep_scan/screens/result_screen.dart';
//import 'result_screen.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({super.key, required this.cameras});

  @override
  // ignore: library_private_types_in_public_api
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with SingleTickerProviderStateMixin {
  late CameraController _controller;
  FlutterTts flutterTts = FlutterTts();
  List<XFile> capturedImages = [];
  bool isFinishEnabled = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _speakInstructions();
    _initializeAnimation();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(
      widget.cameras.first,
      ResolutionPreset.veryHigh,
      enableAudio: false,
    );

    await _controller.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    _animationController.repeat(reverse: true);
  }

  Future<void> _speakInstructions() async {
    await flutterTts
        .speak("Please place the product details inside the rectangular box");
  }

  @override
  void dispose() {
    _controller.dispose();
    flutterTts.stop();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_controller),
          _buildRectangularBox(),
          _buildCaptureButton(),
          _buildFinishButton(),
          _buildThumbnails(),
        ],
      ),
    );
  }

  Widget _buildRectangularBox() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 2),
        ),
        child: CustomPaint(
          painter: ScannerAnimationPainter(progress: _animation.value),
        ),
      ),
    );
  }

  Widget _buildCaptureButton() {
    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: Center(
        child: FloatingActionButton(
          onPressed: _captureImage,
          child: const Icon(Icons.camera),
        ),
      ),
    );
  }

  Widget _buildFinishButton() {
    return Positioned(
      bottom: 16,
      right: 16,
      child: ElevatedButton(
        onPressed: isFinishEnabled ? _finishCapturing : null,
        child: const Text('Finish'),
      ),
    );
  }

  Widget _buildThumbnails() {
    return Positioned(
      bottom: 80,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 80,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: capturedImages.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(4),
              child: Image.file(
                File(capturedImages[index].path),
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _captureImage() async {
    try {
      final image = await _controller.takePicture();
      setState(() {
        capturedImages.add(image);
        isFinishEnabled = capturedImages.length < 4;
      });
      if (capturedImages.length < 4) {
        await flutterTts.speak(
            "Image captured. You can capture more sides or click finish");
      } else {
        _finishCapturing();
      }
    } catch (e) {
      print(e);
    }
  }

  void _finishCapturing() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(images: capturedImages),
      ),
    );
  }
}

class ScannerAnimationPainter extends CustomPainter {
  final double progress;

  ScannerAnimationPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTRB(
          0, size.height * progress, size.width, size.height * progress + 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
