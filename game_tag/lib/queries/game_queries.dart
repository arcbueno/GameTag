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
    mutation UpdateGame($id: ID!, $title: String!, $publisher: String, $hoursPlayed: Float, $rating: Float, $gameStateId: ID!, $platformId: ID! ) {
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

  static const String updateGameWithScreenshots = r"""
    mutation UpdateGame($id: ID!, $title: String!, $publisher: String, $hoursPlayed: Float, $rating: Float, $gameStateId: ID!, $platformId: ID!, $screenshots:[ID!]  ) {
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
            Screenshots: {
              add: $screenshots
            }
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

  static const String removeScreenshot = r"""
    mutation RemoveScreenshot($id: ID!, $screenshotsToRemove:[ID!]  ) {
      updateGame(
        input: {
          id: $id 
          fields: {
            Screenshots: {
              remove: $screenshotsToRemove
            }
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
      deleteGame(
        input: {id: $id}
      ) {
        game {
          id
          Title
          createdAt
          
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
               Screenshots{
                edges{
                  node{
                  objectId,
                    url
                  }
                }
              }
            }
          }
        }
      }
  """;
}
