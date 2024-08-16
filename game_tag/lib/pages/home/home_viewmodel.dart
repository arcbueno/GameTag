import 'package:game_tag/service_locator.dart';
import 'package:game_tag/services/user_service.dart';

class HomeViewModel {
  final UserService _userService;

  // ValueNotifier<LoginState> state = ValueNotifier<LoginState>(LoginFormState());

  HomeViewModel([UserService? userService])
      : _userService = userService ?? getIt.get<UserService>();

  Future<bool> loggoffUser() async {
    try {
      await _userService.loggoffUser();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
