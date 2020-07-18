import 'package:equatable/equatable.dart';
import 'package:quantifico/data/model/auth/session.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class Authenticating extends AuthState {
  const Authenticating();
}

class Authenticated extends AuthState {
  final Session session;

  const Authenticated(this.session);

  @override
  List<Object> get props => [session];
}

class NotAuthenticated extends AuthState {
  const NotAuthenticated();
}
