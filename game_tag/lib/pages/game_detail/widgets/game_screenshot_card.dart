import 'dart:io';

import 'package:flutter/material.dart';

class GameScreenshotCard extends StatelessWidget {
  final Function() onPressed;
  final Function()? onDelete;
  final String imagePath;
  final bool isOnMemory;

  const GameScreenshotCard({
    super.key,
    required this.onPressed,
    this.onDelete,
    required this.imagePath,
    this.isOnMemory = false,
  });

  @override
  Widget build(BuildContext context) {
    var cardSize = MediaQuery.sizeOf(context).width / 3;
    return InkWell(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            isOnMemory
                ? Stack(
                    children: [
                      Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                        width: cardSize,
                        height: cardSize,
                      ),
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.5,
                          child: Container(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  )
                : Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                    width: cardSize,
                    height: cardSize,
                  ),
            if (onDelete != null)
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
