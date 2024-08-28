import 'package:flutter/foundation.dart';
import 'package:game_tag/pages/home/home_state.dart';
import 'package:game_tag/repositories/games_repository.dart';
import 'package:game_tag/service_locator.dart';
import 'package:game_tag/services/user_service.dart';

class HomeViewModel {
  final UserService _userService;
  final GamesRepository _gamesRepository;

  ValueNotifier<HomeState> state = ValueNotifier<HomeState>(LoadingHomeState());

  HomeViewModel([UserService? userService, GamesRepository? gamesRepository])
      : _userService = userService ?? getIt.get<UserService>(),
        _gamesRepository = gamesRepository ?? getIt.get<GamesRepository>() {
    getMyGames();
  }

  Future<void> getMyGames() async {
    state.value = LoadingHomeState();
    try {
      var result = await _gamesRepository.getAllMyGames();
      state.value = SuccessHomeState(result);
    } catch (e) {
      state.value = ErrorHomeState(e.toString());
    }
  }

  Future<bool> loggoffUser() async {
    try {
      await _userService.loggoffUser();
      return true;
    } catch (e) {
      return false;
    }
  }
}
