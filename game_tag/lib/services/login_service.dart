import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class LoginService {
  Future<ParseUser?> loginWithEmailAndPassword(
      String username, String password) async {
    final user = ParseUser(username, password, null);
    final response = await user.login();
    if (response.success) {
      return user;
    } else {
      return null;
    }
  }

  Future<ParseUser?> signUpWithEmailAndPassword(
      String username, String email, String password) async {
    final user = ParseUser.createUser(username, password, email);
    final response = await user.signUp();
    if (response.success) {
      return user;
    } else {
      return null;
    }
  }
}
