import 'package:flutter/material.dart';
import 'package:game_tag/pages/game_detail/game_detail_state.dart';
import 'package:game_tag/pages/game_detail/game_detail_viewmodel.dart';
import 'package:game_tag/pages/game_detail/widgets/empty_screenshot_card.dart';
import 'package:game_tag/pages/game_detail/widgets/game_screenshot_card.dart';
import 'package:game_tag/pages/image_page/image_page.dart';
import 'package:game_tag/utils/sized_box_extension.dart';

class ScreenshotList extends StatelessWidget {
  final GameDetailViewmodel viewmodel;

  const ScreenshotList({super.key, required this.viewmodel});

  @override
  Widget build(BuildContext context) {
    final bool isEditing = viewmodel.state.value is GameDetailStateFilling;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Screenshots',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        if (!isEditing && viewmodel.state.value.game!.screenshots.isEmpty)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.image_not_supported_rounded,
                    size: 128,
                  ),
                  12.h,
                  const Text(
                    'No screenshots added',
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...viewmodel.state.value.game!.screenshots.map((e) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GameScreenshotCard(
                      onDelete: isEditing
                          ? () {
                              viewmodel.onDeleteImage(e.id);
                            }
                          : null,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ImagePage(
                              imagePath: e.url,
                              isFromMemory: false,
                            ),
                          ),
                        );
                      },
                      imagePath: e.url,
                    ),
                  );
                }),
                if (isEditing)
                  ...(viewmodel.state.value as GameDetailStateFilling)
                      .tempImages
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GameScreenshotCard(
                            onDelete: () {
                              viewmodel.onDeleteTempImage(e);
                            },
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ImagePage(
                                    imagePath: e.path,
                                    isFromMemory: true,
                                  ),
                                ),
                              );
                            },
                            imagePath: e.path,
                            isOnMemory: true,
                          ),
                        ),
                      ),
                if (isEditing)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: EmptyScreenshotCard(
                      onPressed: viewmodel.onSelectImages,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
