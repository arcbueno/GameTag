import 'package:game_tag/services/login_service.dart';
import 'package:game_tag/services/user_service.dart';
import 'package:get_it/get_it.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  Future<void> init(String appId, String serverUrl, String clientKey) async {
    var parse = await Parse().initialize(appId, serverUrl,
        clientKey: clientKey, autoSendSessionId: true);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    getIt.registerSingleton(parse);
    getIt.registerSingleton(prefs);
    getIt.registerFactory<LoginService>(LoginService.new);
    getIt.registerFactory<UserService>(UserService.new);
  }
}
