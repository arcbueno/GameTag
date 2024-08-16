import 'package:game_tag/utils/constants.dart';

class ServerData {
  static const keyApplicationId = String.fromEnvironment(Constants.appId);
  static const keyClientKey = String.fromEnvironment(Constants.clientKey);
  static const keyParseServerUrl = String.fromEnvironment(Constants.urlServer);
  static const keyMasterKey = String.fromEnvironment(Constants.masterKey);
}
