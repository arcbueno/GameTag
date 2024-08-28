import 'package:flutter/material.dart';
import 'package:game_tag/models/game.dart';
import 'package:game_tag/pages/game_detail/game_detail_viewmodel.dart';
import 'package:game_tag/pages/game_detail/widgets/screenshot_list.dart';
import 'package:game_tag/utils/sized_box_extension.dart';

class ReadOnlyGame extends StatelessWidget {
  final Game game;
  final GameDetailViewmodel viewmodel;
  const ReadOnlyGame({super.key, required this.game, required this.viewmodel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                12.h,
                Text(
                  'Publisher: ${game.publisher}',
                  style: const TextStyle(fontSize: 18),
                ),
                12.h,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Platform: ${game.platform.name}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'State: ${game.state.name}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                12.h,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Hours played: ${game.hoursPlayed ?? ''}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                24.h,
                if (game.rating != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 0; i < game.rating!.truncate(); i++)
                            const Icon(
                              Icons.star,
                              color: Colors.black,
                              size: 36,
                            ),
                          if (game.rating! % 1 > 0)
                            const Icon(
                              Icons.star_half,
                              color: Colors.black,
                              size: 36,
                            ),
                        ],
                      ),
                      Text(game.ratingReaction),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ScreenshotList(
                    viewmodel: viewmodel,
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
