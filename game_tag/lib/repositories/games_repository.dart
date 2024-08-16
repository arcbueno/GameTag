import 'package:game_tag/service_locator.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GamesRepository {
  final GraphQLClient _client;
  GamesRepository([GraphQLClient? client])
      : _client = client ?? getIt.get<GraphQLClient>();

  Future<void> getAllMyGames() async {}
}
