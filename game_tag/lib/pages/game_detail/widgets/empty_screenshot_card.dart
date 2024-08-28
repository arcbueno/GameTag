import 'package:flutter/material.dart';

class EmptyScreenshotCard extends StatelessWidget {
  final Function() onPressed;
  const EmptyScreenshotCard({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    var cardSize = MediaQuery.sizeOf(context).width / 3;
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.black26,
        ),
        width: cardSize,
        height: cardSize,
        child: const Icon(
          Icons.add_photo_alternate_rounded,
          size: 52,
        ),
      ),
    );
  }
}
