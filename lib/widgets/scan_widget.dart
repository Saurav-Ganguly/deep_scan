import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:deep_scan/screens/result_screen.dart';

class ScanWidget extends StatefulWidget {
  const ScanWidget({super.key});

  @override
  State<ScanWidget> createState() => _ScanWidgetState();
}

class _ScanWidgetState extends State<ScanWidget> {
  late List<CameraDescription> cameras;
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];
  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImages() async {
    final List<XFile> selectedImages = await _picker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      setState(() {
        if (_images.length + selectedImages.length > 4) {
          // If more than 4 images would be selected, only add up to 4
          _images.addAll(selectedImages
              .take(4 - _images.length)
              .map((xfile) => XFile(xfile.path)));
        } else {
          _images.addAll(selectedImages.map((xfile) => XFile(xfile.path)));
        }
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => ResultScreen(
            images: _images,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/camera_screen');
                  },
                  child: const UploadBox(
                    icon: Icon(
                      Icons.camera,
                      size: 40,
                    ),
                    label: 'Scan via Camera',
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: _pickImages,
                  child: const UploadBox(
                    icon: Icon(
                      Icons.file_upload,
                      size: 40,
                    ),
                    label: 'Upload from Gallery',
                  ),
                ),
              ),
            ],
          ),
          // Expanded(
          //   child: Container(
          //     width: double.infinity,
          //     decoration: BoxDecoration(
          //       color: Colors.grey[200],
          //       borderRadius: BorderRadius.circular(40),
          //       border: Border.all(
          //         width: 1,
          //         color: Colors.black,
          //       ),
          //     ),
          //     child: const Column(
          //       children: [
          //         Padding(
          //           padding: EdgeInsets.all(10.0),
          //           child: Text(
          //             '* HOW TO SCAN? *',
          //             style:
          //                 TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class UploadBox extends StatelessWidget {
  const UploadBox({
    super.key,
    required this.icon,
    required this.label,
  });
  final Icon icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 233, 233, 233),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          Text(label),
        ],
      ),
    );
  }
}
