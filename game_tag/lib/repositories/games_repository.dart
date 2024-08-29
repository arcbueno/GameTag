import 'package:game_tag/models/game.dart';
import 'package:game_tag/models/game_state.dart';
import 'package:game_tag/models/platform.dart';
import 'package:game_tag/queries/game_queries.dart';
import 'package:game_tag/service_locator.dart';
import 'package:game_tag/services/user_service.dart';
import 'package:game_tag/utils/custom_exceptions.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GamesRepository {
  final GraphQLClient _client;
  final UserService _userService;
  GamesRepository([GraphQLClient? client, UserService? userService])
      : _client = client ?? getIt.get<GraphQLClient>(),
        _userService = userService ?? getIt.get<UserService>();

  Future<List<Game>> getAllMyGames() async {
    var user = _userService.getLoggedUser();
    if (user == null) {
      throw UserNotLoggedInException();
    }
    var query = QueryOptions(
      document: gql(GameQueries.getAllMyGames),
      variables: <String, String?>{
        'id': user.objectId,
      },
    );
    var result = await _client.query(query);
    if (result.data?['games']?['edges'] == null ||
        result.data?['games']?['edges'].isEmpty) {
      throw NoGamesFoundException();
    }
    var list = (result.data?['games']!['edges'] as List<dynamic>)
        .map((e) => Game.fromMap(e['node']))
        .toList();
    return list;
  }

  Future<void> createGame(String title, String? publisher, int hoursPlayed,
      double? rating, GameState gameState, Platform platform) async {
    var user = _userService.getLoggedUser();
    if (user == null) {
      throw UserNotLoggedInException();
    }
    var query = QueryOptions(
      document: gql(GameQueries.createGame),
      variables: {
        "title": title,
        "publisher": publisher,
        "hoursPlayed": hoursPlayed,
        "rating": rating,
        "userId": user.objectId,
        "stateId": gameState.id,
        "platformId": platform.id,
      },
    );
    var result = await _client.query(query);
    if (result.hasException) {
      throw result.exception!;
    }
  }

  Future<void> updateGame(Game game, List<Screenshot> removeScreenshots) async {
    var user = _userService.getLoggedUser();
    if (user == null) {
      throw UserNotLoggedInException();
    }

    if (removeScreenshots.isNotEmpty) {
      await _removeScreenshots(game, removeScreenshots);
    }

    var query = QueryOptions(
      document: gql(game.screenshots.isEmpty
          ? GameQueries.updateGame
          : GameQueries.updateGameWithScreenshots),
      variables: {
        "id": game.id,
        "title": game.title,
        "publisher": game.publisher,
        "hoursPlayed": game.hoursPlayed,
        "rating": game.rating,
        "gameStateId": game.state.id,
        "platformId": game.platform.id,
        "screenshots": game.screenshots.map((e) => e.id).toList(),
      },
    );
    var result = await _client.query(query);
    if (result.hasException) {
      throw result.exception!;
    }
  }

  Future<void> _removeScreenshots(
      Game game, List<Screenshot> removeScreenshots) async {
    var user = _userService.getLoggedUser();
    if (user == null) {
      throw UserNotLoggedInException();
    }

    var query = QueryOptions(
      document: gql(GameQueries.removeScreenshot),
      variables: {
        "id": game.id,
        "screenshotsToRemove": removeScreenshots.map((e) => e.id).toList()
      },
    );
    var result = await _client.query(query);
    if (result.hasException) {
      throw result.exception!;
    }
  }

  Future<void> updateHoursPlayed(Game game) {
    var user = _userService.getLoggedUser();
    if (user == null) {
      throw UserNotLoggedInException();
    }
    var query = QueryOptions(
      document: gql(GameQueries.updateHoursPlayed),
      variables: {
        "id": game.id,
        "hoursPlayed": game.hoursPlayed,
      },
    );
    return _client.query(query);
  }

  Future<void> deleteGame(Game game) async {
    var user = _userService.getLoggedUser();
    if (user == null) {
      throw UserNotLoggedInException();
    }
    var query = QueryOptions(
      document: gql(GameQueries.deleteGame),
      variables: {
        "id": game.id,
      },
    );
    var result = await _client.query(query);
    if (result.hasException) {
      throw result.exception!;
    }
  }
}
