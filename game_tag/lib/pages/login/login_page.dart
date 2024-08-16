import 'package:flutter/material.dart';
import 'package:game_tag/pages/home/home_page.dart';
import 'package:game_tag/pages/login/login_state.dart';
import 'package:game_tag/pages/login/login_viewmodel.dart';
import 'package:game_tag/pages/login/widgets/login_form.dart';
import 'package:game_tag/pages/login/widgets/sign_up_form.dart';
import 'package:game_tag/utils/sized_box_extension.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final usernameController = TextEditingController();
  final viewmodel = LoginViewModel();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: viewmodel.state,
      builder: (context, state, _) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (viewmodel.isLogin)
                      LoginForm(
                        formKey: formKey,
                        usernameController: usernameController,
                        passwordController: passwordController,
                      )
                    else if (state is SignupFormState)
                      SignUpForm(
                        formKey: formKey,
                        emailController: emailController,
                        passwordController: passwordController,
                        confirmPasswordController: confirmPasswordController,
                        usernameController: usernameController,
                        onBackToLogin: () {
                          FocusScope.of(context).unfocus();
                          _clearPasswords();
                          viewmodel.onBackToLogin();
                        },
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: ElevatedButton(
                        onPressed: () => onMainButtonPressed(context),
                        child: Text(viewmodel.isLogin ? 'Login' : 'Sign up'),
                      ),
                    ),
                    24.h,
                    if (viewmodel.isLogin)
                      TextButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          _clearPasswords();
                          viewmodel.onSignUp();
                        },
                        child: Text(
                          'Sign up',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: Colors.blue),
                        ),
                      ),
                  ],
                ),
                if (viewmodel.isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> onMainButtonPressed(BuildContext context) async {
    FocusScope.of(context).unfocus();
    String? error;
    if (viewmodel.isLogin) {
      error = await viewmodel.login(
          usernameController.text, passwordController.text);
    } else {
      error = await viewmodel.register(
          usernameController.text,
          emailController.text,
          passwordController.text,
          confirmPasswordController.text);
    }

    formKey.currentState?.reset();
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
        ),
      );
      return;
    }
    if (viewmodel.isLogin && context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
      return;
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully'),
        ),
      );
    }
    viewmodel.onBackToLogin();
  }

  void _clearPasswords() {
    passwordController.clear();
    confirmPasswordController.clear();
  }
}
