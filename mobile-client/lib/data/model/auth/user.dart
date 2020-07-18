import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String name;
  final String email;

  const User({
    this.name,
    this.email,
  });

  User.fromJson(Map json)
      : name = json['nome']?.toString(),
        email = json['email']?.toString();

  @override
  List<Object> get props => [
        name,
        email,
      ];

  @override
  String toString() {
    return 'User{name: $name, email: $email}';
  }
}
