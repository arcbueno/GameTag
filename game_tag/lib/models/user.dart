import 'dart:convert';

class User {
  final String email;
  final DateTime loginAt;
  final String username;
  final String sessionToken;

  User({
    required this.email,
    required this.loginAt,
    required this.username,
    required this.sessionToken,
  });

  User copyWith({
    String? email,
    DateTime? loginAt,
    String? username,
    String? sessionToken,
  }) {
    return User(
      email: email ?? this.email,
      loginAt: loginAt ?? this.loginAt,
      username: username ?? this.username,
      sessionToken: sessionToken ?? this.sessionToken,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'email': email});
    result.addAll({'loginAt': loginAt.millisecondsSinceEpoch});
    result.addAll({'username': username});
    result.addAll({'sessionToken': sessionToken});

    return result;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'] ?? '',
      loginAt: DateTime.fromMillisecondsSinceEpoch(map['loginAt']),
      username: map['username'] ?? '',
      sessionToken: map['sessionToken'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(email: $email, loginAt: $loginAt, username: $username, sessionToken: $sessionToken)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.email == email &&
        other.loginAt == loginAt &&
        other.username == username &&
        other.sessionToken == sessionToken;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        loginAt.hashCode ^
        username.hashCode ^
        sessionToken.hashCode;
  }
}
