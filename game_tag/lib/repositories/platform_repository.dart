import 'package:game_tag/models/platform.dart';
import 'package:game_tag/queries/platform_queries.dart';
import 'package:game_tag/service_locator.dart';
import 'package:game_tag/utils/custom_exceptions.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class PlatformRepository {
  final GraphQLClient _client;
  PlatformRepository([GraphQLClient? client])
      : _client = client ?? getIt.get<GraphQLClient>();

  Future<List<Platform>> getAllPlatforms() async {
    var query = QueryOptions(document: gql(PlatformQueries.getPlatforms));
    var result = await _client.query(query);
    if (result.data?['platforms']?['edges'] == null &&
        result.data?['platforms']?['edges'].isEmpty) {
      throw NoPlatformFoundException();
    }
    return (result.data?['platforms']!['edges'] as List<dynamic>)
        .map((e) => Platform.fromMap(e['node']))
        .toList();
  }
}
