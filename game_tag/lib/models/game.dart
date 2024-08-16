class Game {
  final String title;
  final String? publisher;
  final double? rating;
  final double? hoursPlayed;

  Game({
    required this.title,
    this.publisher,
    this.rating,
    this.hoursPlayed,
  });

  Game copyWith({
    String? title,
    String? publisher,
    double? rating,
    double? hoursPlayed,
  }) {
    return Game(
      title: title ?? this.title,
      publisher: publisher ?? this.publisher,
      rating: rating ?? this.rating,
      hoursPlayed: hoursPlayed ?? this.hoursPlayed,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': title});
    if (publisher != null) {
      result.addAll({'publisher': publisher});
    }
    if (rating != null) {
      result.addAll({'rating': rating});
    }
    if (hoursPlayed != null) {
      result.addAll({'hoursPlayed': hoursPlayed});
    }

    return result;
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      title: map['Title'] ?? '',
      publisher: map['Publisher'],
      rating: map['Rating']?.toDouble(),
      hoursPlayed: map['HoursPlayed']?.toDouble(),
    );
  }
}
