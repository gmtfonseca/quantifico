import 'package:equatable/equatable.dart';
import 'package:quantifico/data/model/auth/user.dart';

class Session extends Equatable {
  final User user;
  final String token;

  const Session({
    this.user,
    this.token,
  });

  Session.fromJson(Map json)
      : user = User.fromJson(json['usuario'] as Map),
        token = json['token']?.toString();

  @override
  List<Object> get props => [
        user,
        token,
      ];

  @override
  String toString() {
    return 'Session{user: $user, token: $token}';
  }
}
