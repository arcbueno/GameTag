import 'dart:convert';

class User {
  final String objectId;
  final String email;
  final DateTime loginAt;
  final String username;
  final String sessionToken;

  User({
    required this.objectId,
    required this.email,
    required this.loginAt,
    required this.username,
    required this.sessionToken,
  });

  User copyWith({
    String? objectId,
    String? email,
    DateTime? loginAt,
    String? username,
    String? sessionToken,
  }) {
    return User(
      objectId: objectId ?? this.objectId,
      email: email ?? this.email,
      loginAt: loginAt ?? this.loginAt,
      username: username ?? this.username,
      sessionToken: sessionToken ?? this.sessionToken,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'objectId': objectId});
    result.addAll({'email': email});
    result.addAll({'loginAt': loginAt.millisecondsSinceEpoch});
    result.addAll({'username': username});
    result.addAll({'sessionToken': sessionToken});

    return result;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      objectId: map['objectId'] ?? '',
      email: map['email'] ?? '',
      loginAt: DateTime.fromMillisecondsSinceEpoch(map['loginAt']),
      username: map['username'] ?? '',
      sessionToken: map['sessionToken'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
