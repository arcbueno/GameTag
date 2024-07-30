import 'package:game_tag/service_locator.dart';
import 'package:game_tag/services/user_service.dart';

class SplashViewModel {
  final UserService _userService;

  SplashViewModel([UserService? userService])
      : _userService = userService ?? getIt.get<UserService>();

  bool isLoggedIn() {
    var user = _userService.getLoggedUser();
    return user != null;
  }
}
