import 'package:flutter/material.dart';
import 'package:game_tag/pages/home/home_page.dart';
import 'package:game_tag/pages/login/login_page.dart';
import 'package:game_tag/pages/splash/splash_viewmodel.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final SplashViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = SplashViewModel();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (viewModel.isLoggedIn()) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomePage()));
          return;
        }
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
