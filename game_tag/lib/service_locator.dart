import 'package:game_tag/repositories/game_state_repository.dart';
import 'package:game_tag/repositories/games_repository.dart';
import 'package:game_tag/repositories/platform_repository.dart';
import 'package:game_tag/services/file_service.dart';
import 'package:game_tag/services/login_service.dart';
import 'package:game_tag/services/user_service.dart';
import 'package:game_tag/utils/server_data.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  static Future<void> setupLocator() async {
    getIt.registerSingleton<ServerData>(ServerData());

    var parse = await Parse().initialize(
      ServerData.keyApplicationId,
      ServerData.keyParseServerUrl,
      masterKey: ServerData.keyMasterKey,
      clientKey: ServerData.keyClientKey,
      autoSendSessionId: true,
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    getIt.registerSingleton<GraphQLClient>(
      GraphQLClient(
        link: HttpLink(
          '${ServerData.keyParseServerUrl}/graphql',
          defaultHeaders: {
            "X-Parse-Application-Id": ServerData.keyApplicationId,
            "X-Parse-Client-Key": ServerData.keyClientKey,
            "X-Parse-Master-Key": ServerData.keyMasterKey
          },
        ),
        defaultPolicies: DefaultPolicies(
          query: Policies(
            cacheReread: CacheRereadPolicy.ignoreAll,
            fetch: FetchPolicy.noCache,
          ),
        ),
        cache: GraphQLCache(),
      ),
    );

    getIt.registerSingleton(parse);
    getIt.registerSingleton(prefs);
    getIt.registerFactory<ImagePicker>(ImagePicker.new);
    getIt.registerFactory<FileService>(FileService.new);
    getIt.registerFactory<LoginService>(LoginService.new);
    getIt.registerFactory<UserService>(UserService.new);
    getIt.registerFactory<GamesRepository>(GamesRepository.new);
    getIt.registerFactory<GameStateRepository>(GameStateRepository.new);
    getIt.registerFactory<PlatformRepository>(PlatformRepository.new);
  }
}
