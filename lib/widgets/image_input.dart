import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onAddImage});
  final void Function(File img) onAddImage;
  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _imgFile;
  void _takePicture() async {
    final img = await ImagePicker().pickImage(
        source: ImageSource.camera, maxWidth: double.infinity, maxHeight: 250);

    if (img == null) {
      return;
    }
    setState(() {
      _imgFile = File(img.path);
    });
    widget.onAddImage(_imgFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      width: double.infinity,
      height: 250,
      child: (_imgFile == null)
          ? TextButton.icon(
              onPressed: _takePicture,
              icon: const Icon(Icons.camera),
              label: const Text('Take a picture'),
            )
          : Image.file(
              _imgFile!,
              fit: BoxFit.cover,
            ),
    );
  }
}
