import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImgPickerWidget extends StatefulWidget {
  const ImgPickerWidget({super.key, required this.pickImage});
  final Function pickImage;
  @override
  // ignore: library_private_types_in_public_api
  _ImgPickerWidgetState createState() => _ImgPickerWidgetState();
}

class _ImgPickerWidgetState extends State<ImgPickerWidget> {
  File? _image;
  final picker = ImagePicker();

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        widget.pickImage(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: getImageFromGallery,
          child: const Text('Select Image from Gallery'),
        ),
        const SizedBox(height: 20),
        _image != null
            ? Image.file(
                _image!,
                height: 300,
              )
            : const Text('No image selected'),
      ],
    );
  }
}
