import 'package:flutter/material.dart';
import 'package:game_tag/models/game_state.dart';
import 'package:game_tag/models/platform.dart';
import 'package:game_tag/pages/new_game/new_game_state.dart';
import 'package:game_tag/pages/new_game/new_game_viewmodel.dart';
import 'package:game_tag/widgets/game_form.dart';

class NewGamePage extends StatefulWidget {
  const NewGamePage({super.key});

  @override
  State<NewGamePage> createState() => _NewGamePageState();
}

class _NewGamePageState extends State<NewGamePage> {
  final _viewModel = NewGameViewModel();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController publisherController = TextEditingController();
  int? hoursPlayed = 0;
  double? rating;
  Platform? platform;
  GameState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Game'),
      ),
      body: ValueListenableBuilder(
        valueListenable: _viewModel.state,
        builder: (context, state, _) {
          if (state is! FillingState) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Stack(
              children: [
                GameForm(
                  titleController: titleController,
                  publisherController: publisherController,
                  currentRating: state.rating,
                  onHoursPlayedChanged: (value) {
                    hoursPlayed = int.tryParse(value ?? '');
                  },
                  onRatingChanged: _viewModel.selectRating,
                  onPlatformSelected: _viewModel.selectPlatform,
                  onGameStateSelected: _viewModel.selectGameState,
                  gameStates: state.gameStates,
                  platforms: state.platforms,
                  platformSelected: state.platformSelected,
                  gameStateSelected: state.gameStateSelected,
                  error: state.error,
                  onSave: () async {
                    var error = _viewModel.validate(
                        titleController.text,
                        publisherController.text.isEmpty
                            ? null
                            : publisherController.text,
                        hoursPlayed?.toDouble() ?? 0,
                        state.rating,
                        state.gameStateSelected,
                        state.platformSelected);
                    if (error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error),
                        ),
                      );
                      return;
                    }

                    var success = await _viewModel.createGame(
                      titleController.text,
                      publisherController.text.isEmpty
                          ? null
                          : publisherController.text,
                      hoursPlayed ?? 0,
                      state.rating,
                      state.gameStateSelected!,
                      state.platformSelected!,
                    );
                    if (success && context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  saveButtonText: 'Create new game',
                ),
                if (state.isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
