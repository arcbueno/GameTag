class GameStateQueries {
  static const String getAllGameStates = r'''
    query GetAllGameStates {
      gameStates {
        edges {
          node {
            objectId
            name
            StateInt
          }
        }
      }
    }
  ''';
}
