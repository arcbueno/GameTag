class GameUtils {
  static String getRatingReaction(double? rating) {
    if (rating == null || rating > 5) {
      return 'No rating';
    }
    return switch (rating) {
      0 => 'No rating yet',
      0.5 => 'It was trying... maybe?',
      1 => 'Dude... Terrible',
      1.5 => 'Dude... Terrible',
      2 => 'Meh...',
      2.5 => 'Meh...',
      3 => 'Okay',
      3.5 => 'Okay',
      4 => 'Yeah, it was good',
      4.5 => 'Yeah, it was good',
      5 => 'Wow, fantastic!',
      double() => throw UnimplementedError(),
    };
  }
}
