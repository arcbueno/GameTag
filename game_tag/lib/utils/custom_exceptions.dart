class UserNotLoggedInException implements Exception {
  final String message = 'User not logged in';

  @override
  String toString() {
    return message;
  }
}

class NoGamesFoundException implements Exception {
  final String message = 'No games found';

  @override
  String toString() {
    return message;
  }
}
