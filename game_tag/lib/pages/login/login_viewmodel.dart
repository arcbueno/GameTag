import 'package:flutter/material.dart';
import 'package:game_tag/models/user.dart';
import 'package:game_tag/pages/login/login_state.dart';
import 'package:game_tag/service_locator.dart';
import 'package:game_tag/services/login_service.dart';
import 'package:game_tag/services/user_service.dart';

class LoginViewModel {
  final LoginService _loginService;
  final UserService _userService;

  ValueNotifier<LoginState> state = ValueNotifier<LoginState>(LoginFormState());

  bool get isLoading =>
      (state.value is LoginFormState &&
          (state.value as LoginFormState).isLoading) ||
      (state.value is SignupFormState &&
          (state.value as SignupFormState).isLoading);

  bool get isLogin => state.value is LoginFormState;

  LoginViewModel([LoginService? loginService, UserService? userService])
      : _loginService = loginService ?? getIt.get<LoginService>(),
        _userService = userService ?? getIt.get<UserService>();

  Future<String?> login(String username, String password) async {
    state.value = LoginFormState(isLoading: true);
    var error = validateLogin(username, password);
    if (error != null) {
      return error;
    }

    try {
      var result =
          await _loginService.loginWithEmailAndPassword(username, password);
      if (result == null) {
        state.value = LoginFormState(errorMessage: 'Login failed');
        return 'Login failed';
      }
      var user = User(
        objectId: result.objectId ?? '',
        email: result.emailAddress ?? '',
        loginAt: DateTime.now(),
        username: result.username ?? '',
        sessionToken: result.sessionToken ?? '',
      );

      await _userService.loginUser(user);

      state.value = LoginFormState();
    } catch (e) {
      state.value = LoginFormState();
      return e.toString();
    }
    return null;
  }

  Future<String?> register(String username, String email, String password,
      String confirmPassword) async {
    state.value = SignupFormState(isLoading: true);
    var error = validateRegister(username, email, password, confirmPassword);
    if (error != null) {
      state.value = SignupFormState();
      return error;
    }

    try {
      var result = await _loginService.signUpWithEmailAndPassword(
          username, email, password);

      state.value = SignupFormState();
      if (result == null) {
        return 'Failed to register';
      }
    } catch (e) {
      state.value = SignupFormState();
      return e.toString();
    }
    return null;
  }

  String? validateLogin(String username, String password) {
    if (username.isEmpty) {
      return 'Username cannot be empty';
    }
    if (password.isEmpty) {
      return 'Password cannot be empty';
    }
    return null;
  }

  String? validateRegister(
      String username, String email, String password, String confirmPassword) {
    if (username.isEmpty) {
      return 'Username cannot be empty';
    }
    if (email.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!email.contains('@')) {
      return 'Invalid email format';
    }
    if (password.isEmpty) {
      return 'Password cannot be empty';
    }
    if (password.length < 5) {
      return 'Password must be at least 5 characters long';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  void onSignUp() {
    state.value = SignupFormState();
  }

  onBackToLogin() {
    state.value = LoginFormState();
  }
}
