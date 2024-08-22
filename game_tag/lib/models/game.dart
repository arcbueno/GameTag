import 'package:game_tag/models/game_state.dart';
import 'package:game_tag/models/platform.dart';

class Game {
  final String title;
  final String? publisher;
  final double? rating;
  final double? hoursPlayed;
  final Platform platform;
  final GameState state;

  Game({
    required this.title,
    this.publisher,
    this.rating,
    this.hoursPlayed,
    required this.state,
    required this.platform,
  });

  Game copyWith({
    String? title,
    String? publisher,
    double? rating,
    double? hoursPlayed,
    GameState? state,
    Platform? platform,
  }) {
    return Game(
      title: title ?? this.title,
      publisher: publisher ?? this.publisher,
      rating: rating ?? this.rating,
      hoursPlayed: hoursPlayed ?? this.hoursPlayed,
      state: state ?? this.state,
      platform: platform ?? this.platform,
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
    result.addAll({'state': state.id});
    result.addAll({'platform': platform.id});

    return result;
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      title: map['Title'] ?? '',
      publisher: map['Publisher'],
      rating: map['Rating']?.toDouble(),
      hoursPlayed: map['HoursPlayed']?.toDouble(),
      platform: Platform.fromMap(map['Platform']['edges'][0]['node']),
      state: GameState.fromMap(map['State']['edges'][0]['node']),
    );
  }
}
