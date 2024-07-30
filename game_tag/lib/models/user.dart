import 'dart:convert';

class User {
  final String email;
  final DateTime loginAt;
  User({
    required this.email,
    required this.loginAt,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'email': email});
    result.addAll({'loginAt': loginAt.millisecondsSinceEpoch});

    return result;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'] ?? '',
      loginAt: DateTime.fromMillisecondsSinceEpoch(map['loginAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
