import 'package:game_tag/models/game.dart';
import 'package:game_tag/models/game_state.dart';
import 'package:game_tag/models/platform.dart';
import 'package:image_picker/image_picker.dart';

sealed class GameDetailState {
  final Game? game;

  GameDetailState._(this.game);
}

class GameDetailStateLoading extends GameDetailState {
  GameDetailStateLoading(super.game) : super._();
}

class GameDetailStateError extends GameDetailState {
  final String message;

  GameDetailStateError(super.game, this.message) : super._();
}

class GameDetailStateFilling extends GameDetailState {
  final String? error;
  final List<GameState> gamesStates;
  final List<Platform> platforms;
  final bool isLoading;
  final List<XFile> tempImages;

  GameDetailStateFilling(
    super.game, {
    required this.gamesStates,
    required this.platforms,
    this.error,
    this.isLoading = false,
    this.tempImages = const [],
  }) : super._();

  GameDetailStateFilling copyWith({
    Game? game,
    String? error,
    List<GameState>? gamesStates,
    List<Platform>? platforms,
    bool? isLoading,
    List<XFile>? tempImages,
  }) {
    return GameDetailStateFilling(
      game ?? this.game,
      gamesStates: gamesStates ?? this.gamesStates,
      platforms: platforms ?? this.platforms,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      tempImages: tempImages ?? this.tempImages,
    );
  }
}

class GameDetailStateReadOnly extends GameDetailState {
  GameDetailStateReadOnly(super.game) : super._();
}
