import 'package:flutter/material.dart';
import 'package:game_tag/pages/splash/splash_page.dart';
import 'package:game_tag/service_locator.dart';
import 'package:game_tag/utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const keyApplicationId = String.fromEnvironment(Constants.appId);
  const keyClientKey = String.fromEnvironment(Constants.clientKey);
  const keyParseServerUrl = String.fromEnvironment(Constants.urlServer);

  await ServiceLocator()
      .init(keyApplicationId, keyParseServerUrl, keyClientKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GameTag',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}
