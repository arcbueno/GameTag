import 'package:game_tag/models/game_state.dart';
import 'package:game_tag/models/platform.dart';

sealed class NewGameState {
  NewGameState._();
}

class LoadingState extends NewGameState {
  LoadingState() : super._();
}

class FillingState extends NewGameState {
  final List<Platform> platforms;
  final List<GameState> gameStates;
  final bool isLoading;
  final GameState? gameStateSelected;
  final Platform? platformSelected;
  final double? rating;
  final String? error;

  FillingState({
    required this.platforms,
    required this.gameStates,
    this.isLoading = false,
    this.gameStateSelected,
    this.platformSelected,
    this.rating,
    this.error,
  }) : super._();

  FillingState copyWith({
    List<Platform>? platforms,
    List<GameState>? gameStates,
    bool? isLoading,
    GameState? gameStateSelected,
    Platform? platformSelected,
    double? rating,
    String? error,
  }) {
    return FillingState(
      platforms: platforms ?? this.platforms,
      gameStates: gameStates ?? this.gameStates,
      isLoading: isLoading ?? this.isLoading,
      gameStateSelected: gameStateSelected ?? this.gameStateSelected,
      platformSelected: platformSelected ?? this.platformSelected,
      rating: rating ?? this.rating,
      error: error ?? this.error,
    );
  }
}

class ErrorState extends NewGameState {
  final String message;

  ErrorState(this.message) : super._();
}
