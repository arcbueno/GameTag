class GameQueries {
  static const String getAllMyGames = r'''
      query GetMyAllGames($id: ID!) {
        games(where: {
          CreatedBy: {
            have: {
              objectId: {
                equalTo: $id
              }
            }
          }
        }
        ) {
          edges {
            node {
              Title
              Publisher,
              Rating,
              hoursPlayed,
              
            }
          }
        }
    }
  ''';
}
