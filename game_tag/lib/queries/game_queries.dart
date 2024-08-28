class GameQueries {
  static const String createGame = r"""
    mutation CreateGame($title: String!, $publisher: String, $hoursPlayed: Float, $rating: Float, $userId: ID!, $stateId: ID!, $platformId: ID!) {
    createGame(
      input: {fields: {Title: $title, Publisher: $publisher, hoursPlayed: $hoursPlayed, Rating: $rating,  CreatedBy: {link: $userId}, State: {link:$stateId}, Platform:{link: $platformId} }}
    ) {
      game {
        id
        Title
        createdAt
        CreatedBy {
          email
        }
      }
    }
  }
  """;

  static const String updateGame = r"""
    mutation UpdateGame($id: ID!, $title: String!, $publisher: String, $hoursPlayed: Float, $rating: Float, $gameStateId: ID!, $platformId: ID!, $screenshotList: [Any] ) {
      updateGame(
        input: {
          id: $id 
          fields: {
            Title: $title, 
            Publisher: $publisher, 
            hoursPlayed: $hoursPlayed, 
            Rating: $rating,
            State:{link:$gameStateId}, 
            Platform: {link: $platformId }
            Screenshots: $screenshotList
          }
        }
      ) {
        game {
          id
          Title
          createdAt
          CreatedBy {
            email
          }
        }
      }
    }

    """;

  static const String updateHoursPlayed = r"""
    mutation UpdateGame($id: ID!, $hoursPlayed: Float) {
      updateGame(
        input: {
          id: $id 
          fields: {
            hoursPlayed: $hoursPlayed,  
            }}
      ) {
        game {
          id
          Title
          createdAt
          CreatedBy {
            email
          }
        }
      }
    }

    """;

  static const String deleteGame = r"""
    mutation DeleteGame($id: ID!) {
      updateGame(
        input: {id: $id}
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
              objectId,
              Title
              Publisher
              Rating
              hoursPlayed,
              Platform {
                  objectId,
                    name,
                    PlatformInt
              }
              State{
                objectId,
                  name,
                  StateInt
              }
            }
          }
        }
      }
  """;
}
