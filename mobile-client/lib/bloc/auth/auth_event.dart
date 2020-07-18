import 'package:equatable/equatable.dart';
import 'package:quantifico/data/model/auth/session.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class CheckAuthentication extends AuthEvent {
  const CheckAuthentication();

  @override
  String toString() => 'CheckAuthentication';
}

class DeAuthenticate extends AuthEvent {
  const DeAuthenticate();
}

class Authenticate extends AuthEvent {
  final Session session;
  const Authenticate({this.session});

  @override
  String toString() => 'Authenticate';
}
