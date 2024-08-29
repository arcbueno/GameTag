import 'package:flutter/foundation.dart';
import 'package:game_tag/models/game.dart';
import 'package:game_tag/models/game_state.dart';
import 'package:game_tag/models/platform.dart';
import 'package:game_tag/pages/game_detail/game_detail_state.dart';
import 'package:game_tag/repositories/game_state_repository.dart';
import 'package:game_tag/repositories/games_repository.dart';
import 'package:game_tag/repositories/platform_repository.dart';
import 'package:game_tag/service_locator.dart';
import 'package:game_tag/services/file_service.dart';
import 'package:image_picker/image_picker.dart';

class GameDetailViewmodel {
  final GamesRepository _gamesRepository;
  final GameStateRepository _gameStateRepository;
  final PlatformRepository _platformRepository;
  final FileService _fileService;
  final List<Screenshot> screenshotsToRemove = [];

  ValueNotifier<GameDetailState> state =
      ValueNotifier<GameDetailState>(GameDetailStateReadOnly(null));

  GameDetailViewmodel(
    Game game, [
    GamesRepository? gamesRepository,
    GameStateRepository? gameStateRepository,
    PlatformRepository? platformRepository,
    FileService? fileService,
  ])  : _gamesRepository = gamesRepository ?? getIt.get<GamesRepository>(),
        _gameStateRepository =
            gameStateRepository ?? getIt.get<GameStateRepository>(),
        _platformRepository =
            platformRepository ?? getIt.get<PlatformRepository>(),
        _fileService = fileService ?? getIt.get<FileService>() {
    state.value = GameDetailStateReadOnly(game);
  }

  onSelectImages() async {
    var images = await _fileService.getImages();
    if (images.isEmpty) return;
    state.value = (state.value as GameDetailStateFilling).copyWith(
      tempImages: (state.value as GameDetailStateFilling).tempImages + images,
    );
  }

  Future<bool> deleteGame() async {
    state.value = GameDetailStateLoading(state.value.game);
    try {
      await _gamesRepository.deleteGame(state.value.game!);
      state.value = GameDetailStateReadOnly(null);
      return true;
    } catch (e) {
      state.value = GameDetailStateError(state.value.game, e.toString());
      return false;
    }
  }

  Future<void> getData() {
    state.value = GameDetailStateLoading(state.value.game);
    return Future.wait([
      _gameStateRepository.getAllGameStates(),
      _platformRepository.getAllPlatforms(),
    ]).then((value) {
      state.value = GameDetailStateFilling(
        state.value.game,
        gamesStates: (value[0] as List<GameState>),
        platforms: (value[1] as List<Platform>),
      );
    }).catchError((error) {
      state.value = GameDetailStateError(state.value.game, error.toString());
    });
  }

  onSetEditMode() {
    getData();
  }

  onSetReadOnlyMode() {
    state.value = GameDetailStateReadOnly(state.value.game);
  }

  Future<bool> updateGame(
      String title, String? publisher, int? hoursPlayed) async {
    var game = state.value.game!.copyWith(
        title: title, publisher: publisher, hoursPlayed: hoursPlayed ?? 0);

    state.value = (state.value as GameDetailStateFilling).copyWith(
      game: game,
      isLoading: true,
    );
    try {
      var screenshots = await _uploadImages();
      var currentScreenshots = [...game.screenshots];
      currentScreenshots.addAll(screenshots);
      game = game.copyWith(screenshots: currentScreenshots);
      await _gamesRepository.updateGame(game, screenshotsToRemove);
      state.value = GameDetailStateReadOnly(game);
      return true;
    } catch (e) {
      state.value = GameDetailStateError(game, e.toString());
      return false;
    }
  }

  Future<List<Screenshot>> _uploadImages() async {
    if ((state.value as GameDetailStateFilling).tempImages.isEmpty) return [];
    return await _fileService.uploadImages(
        (state.value as GameDetailStateFilling).tempImages, state.value.game!);
  }

  selectRating(double rating) {
    state.value = (state.value as GameDetailStateFilling).copyWith(
      game: state.value.game!.copyWith(rating: rating),
    );
  }

  selectPlatform(Platform platform) {
    state.value = (state.value as GameDetailStateFilling).copyWith(
      game: state.value.game!.copyWith(platform: platform),
    );
  }

  selectGameState(GameState gameState) {
    state.value = (state.value as GameDetailStateFilling).copyWith(
      game: state.value.game!.copyWith(state: gameState),
    );
  }

  validate(String title, String? publisher, int? hoursPlayed) {
    if (title.isEmpty) {
      return 'Title cannot be empty';
    }
    if (publisher == null || publisher.isEmpty) {
      return 'Publisher cannot be empty';
    }
    if (hoursPlayed != null && hoursPlayed < 0) {
      return 'Hours played cannot be negative';
    }
    return null;
  }

  void onDeleteTempImage(XFile e) {
    (state.value as GameDetailStateFilling).tempImages.remove(e);
    state.value = (state.value as GameDetailStateFilling).copyWith();
  }

  void onDeleteImage(String id) {
    screenshotsToRemove.add(state.value.game!.screenshots
        .firstWhere((element) => element.id == id));
    (state.value as GameDetailStateFilling)
        .game!
        .screenshots
        .removeWhere((e) => e.id == id);
    state.value = (state.value as GameDetailStateFilling).copyWith();
  }
}
