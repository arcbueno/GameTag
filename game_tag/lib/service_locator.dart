import 'package:game_tag/services/login_service.dart';
import 'package:game_tag/services/user_service.dart';
import 'package:game_tag/utils/server_data.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  static Future<void> setupLocator() async {
    getIt.registerSingleton<ServerData>(ServerData());

    var parse = await Parse().initialize(
      ServerData.keyApplicationId,
      ServerData.keyParseServerUrl,
      clientKey: ServerData.keyClientKey,
      autoSendSessionId: true,
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _registerBlankGraphQLClient();

    getIt.registerSingleton(parse);
    getIt.registerSingleton(prefs);
    getIt.registerFactory<LoginService>(LoginService.new);
    getIt.registerFactory<UserService>(UserService.new);
  }

  static onLogin(String sessionId) {
    if (getIt.isRegistered<GraphQLClient>()) {
      getIt.unregister<GraphQLClient>();
    }
    getIt.registerSingleton<GraphQLClient>(
      GraphQLClient(
        link: HttpLink(ServerData.keyParseServerUrl, defaultHeaders: {
          "X-Parse-Application-Id": "lNmkcXTVKDfoXOyGgAtg7gvGuG4Iv39LftvZDZKg",
          "X-Parse-Master-Key": sessionId,
          "X-Parse-Client-Key": "FSa3YYPyigFBhkkf2PPw6B0lsAoMakIA2hWxMXWL"
        }),
        cache: GraphQLCache(),
      ),
    );
  }

  static onLoggoff() {
    _registerBlankGraphQLClient();
  }

  static _registerBlankGraphQLClient() {
    if (getIt.isRegistered<GraphQLClient>()) {
      getIt.unregister<GraphQLClient>();
    }
    getIt.registerSingleton<GraphQLClient>(
      GraphQLClient(
        link: HttpLink(
          ServerData.keyParseServerUrl,
        ),
        cache: GraphQLCache(),
      ),
    );
  }
}
