import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePage extends StatelessWidget {
  final bool isFromMemory;
  final String imagePath;
  const ImagePage(
      {super.key, this.isFromMemory = false, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider:
          isFromMemory ? FileImage(File(imagePath)) : NetworkImage(imagePath),
    );
  }
}
