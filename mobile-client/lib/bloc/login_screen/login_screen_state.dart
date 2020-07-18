import 'package:equatable/equatable.dart';
import 'package:quantifico/data/model/auth/session.dart';

abstract class LoginScreenState extends Equatable {
  const LoginScreenState();

  @override
  List<Object> get props => [];
}

class LoginScreenLoaded extends LoginScreenState {
  final String email;

  const LoginScreenLoaded({this.email});
}

class SigningIn extends LoginScreenState {
  const SigningIn();
}

class NotSignedIn extends LoginScreenState {
  final String error;

  const NotSignedIn({this.error});

  @override
  List<Object> get props => [error];
}

class SignedIn extends LoginScreenState {
  final Session session;

  const SignedIn(this.session);

  @override
  List<Object> get props => [session];
}
