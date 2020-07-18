import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/auth/barrel.dart';
import 'package:quantifico/bloc/login_screen/barrel.dart';
import 'package:quantifico/data/repository/user_repository.dart';
import 'package:quantifico/presentation/screen/login_screen.dart';

class AuthGuard extends StatelessWidget {
  final UserRepository userRepository;
  final Widget child;

  const AuthGuard({
    @required this.userRepository,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticating) {
          return Container(color: Colors.white);
        } else if (state is Authenticated) {
          return child;
        } else {
          return LoginScreen(
            bloc: LoginScreenBloc(userRepository: userRepository)..add(LoadLoginScreen()),
          );
        }
      },
    );
  }
}
