import 'package:flutter/material.dart';
import 'package:game_tag/models/game_state.dart';
import 'package:game_tag/models/platform.dart';
import 'package:game_tag/pages/new_game/new_game_state.dart';
import 'package:game_tag/repositories/game_state_repository.dart';
import 'package:game_tag/repositories/games_repository.dart';
import 'package:game_tag/repositories/platform_repository.dart';

class NewGameViewModel {
  final GameStateRepository _gameStateRepository;
  final PlatformRepository _platformRepository;
  final GamesRepository _gamesRepository;

  ValueNotifier<NewGameState> state =
      ValueNotifier<NewGameState>(LoadingState());

  NewGameViewModel(
      [GameStateRepository? gameStateRepository,
      PlatformRepository? platformRepository,
      GamesRepository? gamesRepository])
      : _gameStateRepository = gameStateRepository ?? GameStateRepository(),
        _platformRepository = platformRepository ?? PlatformRepository(),
        _gamesRepository = gamesRepository ?? GamesRepository() {
    getData();
  }

  void selectGameState(GameState state) {
    if (this.state.value is FillingState) {
      this.state.value =
          (this.state.value as FillingState).copyWith(gameStateSelected: state);
    }
  }

  void selectPlatform(Platform platform) {
    if (state.value is FillingState) {
      state.value =
          (state.value as FillingState).copyWith(platformSelected: platform);
    }
  }

  void selectRating(double rating) {
    if (state.value is FillingState) {
      state.value = (state.value as FillingState).copyWith(rating: rating);
    }
  }

  Future<void> getData() {
    state.value = LoadingState();
    return Future.wait([
      _gameStateRepository.getAllGameStates(),
      _platformRepository.getAllPlatforms(),
    ]).then((value) {
      state.value = FillingState(
        gameStates: (value[0] as List<GameState>),
        platforms: (value[1] as List<Platform>),
      );
    }).catchError((error) {
      state.value = ErrorState(error);
    });
  }

  Future<bool> createGame(String title, String? publisher, int hoursPlayed,
      double? rating, GameState gameState, Platform platform) async {
    if (state.value is! FillingState) return false;
    state.value = (state.value as FillingState).copyWith(isLoading: true);
    return _gamesRepository
        .createGame(title, publisher, hoursPlayed, rating, gameState, platform)
        .then((value) {
      return true;
    }).catchError((error) {
      state.value = state.value is FillingState
          ? (state.value as FillingState).copyWith(error: error.toString())
          : ErrorState(error.toString());
      return false;
    });
  }

  String? validate(String title, String? publisher, double hoursPlayed,
      double? rating, GameState? gameState, Platform? platform) {
    if (title.isEmpty) {
      return 'Title cannot be empty';
    }
    if (hoursPlayed < 0) {
      return 'Hours played cannot be negative';
    }
    if (rating != null && (rating < 0 || rating > 10)) {
      return 'Rating must be between 0 and 5';
    }
    if (gameState == null) {
      return 'Select a game state';
    }
    if (platform == null) {
      return 'Select a platform';
    }

    return null;
  }
}
