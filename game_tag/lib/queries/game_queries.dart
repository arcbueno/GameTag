class GameQueries {
  static const String createGame = r"""
    mutation CreateGame($title: String!, $publisher: String, $hoursPlayed: Float, $rating: Float, $userId: [ID!], $gameStateId: [ID!], $platformId: [ID!] ) {
      createGame(
        input: {fields: {Title: $title, Publisher: $publisher, hoursPlayed: $hoursPlayed, Rating: $rating,  CreatedBy:{add:$userId}, State: {add: $gameStateId}, Platform: {add: $platformId} }}
      ) {
        game {
          id
          Title
          createdAt
          CreatedBy {
            edges {
              node {
                email
              }
            }
          }
        }
      }
    }
  """;

  static const String getAllMyGames = r"""
      query GetMyAllGames($id: ID!) {
        games(where: {CreatedBy: {have: {objectId: {equalTo: $id}}}}, order: Title_ASC) {
          edges {
            node {
              Title
              Publisher
              Rating
              hoursPlayed,
              Platform {
                edges{
                  node{
                    objectId,
                    name,
                    PlatformInt
                  }
                }
              }
              State{
                edges{
                  node{
                    objectId,
                    name,
                    StateInt
                  }
                }
              }
            }
          }
        }
      }
  """;
}
