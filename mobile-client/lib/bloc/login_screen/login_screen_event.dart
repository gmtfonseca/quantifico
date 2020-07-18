import 'package:equatable/equatable.dart';

abstract class LoginScreenEvent extends Equatable {
  const LoginScreenEvent();

  @override
  List<Object> get props => [];
}

class SignIn extends LoginScreenEvent {
  final String email;
  final String password;

  const SignIn({this.email, this.password});

  @override
  String toString() => 'SignIn';
}

class LoadLoginScreen extends LoginScreenEvent {
  const LoadLoginScreen();
}
