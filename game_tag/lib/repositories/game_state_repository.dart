import 'package:game_tag/models/game_state.dart';
import 'package:game_tag/queries/game_state_queries.dart';
import 'package:game_tag/service_locator.dart';
import 'package:game_tag/utils/custom_exceptions.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GameStateRepository {
  final GraphQLClient _client;
  GameStateRepository([GraphQLClient? client])
      : _client = client ?? getIt.get<GraphQLClient>();

  Future<List<GameState>> getAllGameStates() async {
    var query = QueryOptions(document: gql(GameStateQueries.getAllGameStates));
    var result = await _client.query(query);
    if (result.data?['gameStates']?['edges'] == null &&
        result.data?['gameStates']?['edges'].isEmpty) {
      throw NoGameStateFoundException();
    }
    return (result.data?['gameStates']!['edges'] as List<dynamic>)
        .map((e) => GameState.fromMap(e['node']))
        .toList();
  }
}
