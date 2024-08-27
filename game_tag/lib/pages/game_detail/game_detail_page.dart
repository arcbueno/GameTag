import 'package:flutter/material.dart';
import 'package:game_tag/models/game.dart';
import 'package:game_tag/models/game_state.dart';
import 'package:game_tag/models/platform.dart';
import 'package:game_tag/pages/game_detail/game_detail_state.dart';
import 'package:game_tag/pages/game_detail/game_detail_viewmodel.dart';
import 'package:game_tag/pages/game_detail/widgets/read_only_game.dart';
import 'package:game_tag/widgets/game_form.dart';

class GameDetailPage extends StatefulWidget {
  final Game game;
  const GameDetailPage({super.key, required this.game});

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  late final GameDetailViewmodel _viewModel;
  late final TextEditingController titleController;
  late final TextEditingController publisherController;
  int? hoursPlayed;
  double? rating;
  Platform? platform;
  GameState? state;

  @override
  void initState() {
    _viewModel = GameDetailViewmodel(widget.game);
    titleController = TextEditingController(text: widget.game.title);
    publisherController = TextEditingController(text: widget.game.publisher);
    hoursPlayed = widget.game.hoursPlayed;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _viewModel.state,
      builder: (context, state, _) {
        return PopScope(
          onPopInvoked: (didPop) {
            if (didPop) return;
            if (state is GameDetailStateReadOnly) {
              Navigator.pop(context);
            } else {
              _viewModel.onSetReadOnlyMode();
            }
          },
          canPop: false,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: state.game?.title != null
                  ? Text(state.game!.title)
                  : const Text('Game...'),
              actions: [
                IconButton(
                  onPressed: () {
                    if (state is GameDetailStateReadOnly) {
                      _viewModel.onSetEditMode();
                    } else {
                      _viewModel.onSetReadOnlyMode();
                    }
                  },
                  icon: state is GameDetailStateReadOnly
                      ? const Icon(Icons.edit)
                      : const Icon(Icons.save),
                ),
                IconButton(
                  onPressed: () async {
                    _viewModel.deleteGame().then((result) {
                      if (result) {
                        Navigator.of(context).pop();
                      }
                    });
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            body: Builder(
              builder: (context) {
                if (state is GameDetailStateReadOnly) {
                  return ReadOnlyGame(
                    game: state.game!,
                  );
                }
                if (state is GameDetailStateFilling) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: GameForm(
                      titleController: titleController,
                      publisherController: publisherController,
                      currentRating: state.game?.rating,
                      onHoursPlayedChanged: (value) {
                        hoursPlayed = int.tryParse(value ?? '');
                      },
                      onRatingChanged: _viewModel.selectRating,
                      onPlatformSelected: _viewModel.selectPlatform,
                      onGameStateSelected: _viewModel.selectGameState,
                      gameStates: state.gamesStates,
                      platforms: state.platforms,
                      platformSelected: state.game?.platform,
                      gameStateSelected: state.game?.state,
                      error: state.error,
                      hoursPlayed: hoursPlayed,
                      onSave: () async {
                        var error = _viewModel.validate(
                          titleController.text,
                          publisherController.text.isEmpty
                              ? null
                              : publisherController.text,
                          hoursPlayed,
                        );
                        if (error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error),
                            ),
                          );
                          return;
                        }
                        _viewModel.updateGame(titleController.text,
                            publisherController.text, hoursPlayed);
                      },
                      saveButtonText: 'Update game',
                    ),
                  );
                }
                if (state is GameDetailStateLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Container();
              },
            ),
          ),
        );
      },
    );
  }
}
