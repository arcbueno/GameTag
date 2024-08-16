import 'package:game_tag/models/user.dart';
import 'package:game_tag/service_locator.dart';
import 'package:game_tag/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final SharedPreferences _sharedPreferences;

  UserService([SharedPreferences? sharedPreferences])
      : _sharedPreferences =
            sharedPreferences ?? getIt.get<SharedPreferences>();

  User? getLoggedUser() {
    var userString = _sharedPreferences.getString(Constants.userDataKey);
    if (userString == null) return null;
    return User.fromJson(userString);
  }

  Future<void> loginUser(User user) async {
    await _storageUser(user);
  }

  Future<void> loggoffUser() async {
    await _sharedPreferences.remove(Constants.userDataKey);
  }

  Future<void> _storageUser(User user) async {
    await _sharedPreferences.setString(Constants.userDataKey, user.toJson());
  }
}
