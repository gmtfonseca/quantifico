import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/auth/barrel.dart';
import 'package:quantifico/bloc/login_screen/barrel.dart';
import 'package:quantifico/presentation/shared/loading_indicator.dart';

class LoginScreen extends StatelessWidget {
  final LoginScreenBloc bloc;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  LoginScreen({this.bloc})
      : emailController = TextEditingController(),
        passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginScreenBloc, LoginScreenState>(
      bloc: bloc,
      listener: (context, state) {
        if (state is SignedIn) {
          final authBloc = BlocProvider.of<AuthBloc>(context);
          authBloc.add(Authenticate(session: state.session));
        }
      },
      child: BlocBuilder<LoginScreenBloc, LoginScreenState>(
        bloc: bloc,
        builder: (context, state) {
          return Scaffold(
            body: ListView(
              children: <Widget>[
                CustomPaint(
                  painter: OvalPainter(),
                  child: Container(height: 60),
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      _buildLogo(),
                      const SizedBox(height: 20.0),
                      _buildFields(context, state),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogo() {
    return const SizedBox(
      height: 180,
      width: 180,
      child: Center(
        child: Opacity(
          opacity: 0.95,
          child: Image(
            image: AssetImage('assets/logo.png'),
          ),
        ),
      ),
    );
  }

  Widget _buildFields(BuildContext context, LoginScreenState state) {
    return SizedBox(
      width: 300,
      child: Column(
        children: <Widget>[
          _buildEmailField(state),
          const SizedBox(height: 20.0),
          _buildPasswordField(state),
          const SizedBox(height: 20.0),
          _buildInvalidCredentialsText(state),
          const SizedBox(height: 40.0),
          _buildSigninButton(context, state),
        ],
      ),
    );
  }

  Widget _buildEmailField(LoginScreenState state) {
    if (state is LoginScreenLoaded) {
      emailController.text = state.email;
    }
    return TextField(
      controller: emailController,
      decoration: const InputDecoration(
        // border: OutlineInputBorder(),
        labelText: 'Email',
      ),
      enabled: state is! SigningIn,
    );
  }

  Widget _buildPasswordField(LoginScreenState state) {
    return TextField(
      controller: passwordController,
      decoration: const InputDecoration(
        // border: OutlineInputBorder(),
        labelText: 'Senha',
      ),
      enabled: state is! SigningIn,
      obscureText: true,
    );
  }

  Widget _buildInvalidCredentialsText(LoginScreenState state) {
    if (state is NotSignedIn && state.error != null) {
      return Align(
        alignment: Alignment.topLeft,
        child: Text(
          state.error,
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildSigninButton(BuildContext context, LoginScreenState state) {
    if (state is SigningIn) {
      return const LoadingIndicator();
    } else {
      return Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 60.0,
              child: FlatButton(
                onPressed: () {
                  bloc.add(SignIn(
                    email: emailController.text,
                    password: passwordController.text,
                  ));
                },
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                child: const Text('ENTRAR'),
              ),
            ),
          ),
        ],
      );
    }
  }
}

class OvalPainter extends CustomPainter {
  static const double _kCurveHeight = 35;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Path();
    p.lineTo(0, size.height - _kCurveHeight);
    p.relativeQuadraticBezierTo(size.width / 2, 2 * _kCurveHeight, size.width, 0);
    p.lineTo(size.width, 0);
    p.close();

    canvas.drawPath(p, Paint()..color = Colors.deepPurple);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
