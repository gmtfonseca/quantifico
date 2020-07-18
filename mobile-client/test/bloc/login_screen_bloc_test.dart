import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quantifico/bloc/login_screen/barrel.dart';
import 'package:quantifico/data/model/auth/session.dart';
import 'package:quantifico/data/model/auth/user.dart';
import 'package:quantifico/data/repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  const TOKEN =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVkZTZmMjUwZjI3OTI2M2I0OGJhNWYyYiIsIm9yZ2FuaXphY2FvIjoiNWRlNmYyND'
      'FmMjc5MjYzYjQ4YmE1ZjJhIiwiaWF0IjoxNTkwMjY2Mzc4LCJleHAiOjE1OTAzNTI3Nzh9.SBIx1wWespyhl2YaeOukjmKaAdXBn0z94bu4gSXh0qw';

  group('LoginScreenBloc', () {
    UserRepository userRepository;
    LoginScreenBloc loginScreenBloc;

    setUp(() {
      userRepository = MockUserRepository();
      loginScreenBloc = LoginScreenBloc(userRepository: userRepository);
    });

    const session = Session(
      user: User(email: 'john@doe', name: 'John Doe'),
      token: TOKEN,
    );

    blocTest<LoginScreenBloc, LoginScreenEvent, LoginScreenState>(
      'should emit LoginScreenLoaded with email when there is a valid session',
      build: () {
        when(userRepository.getSession()).thenAnswer((_) => Future.value(session));
        return loginScreenBloc;
      },
      act: (LoginScreenBloc bloc) async => bloc.add(
        const LoadLoginScreen(),
      ),
      expect: <LoginScreenState>[
        const NotSignedIn(),
        LoginScreenLoaded(email: session.user.email),
      ],
    );

    const email = 'johne@doe';
    const password = 'doe';

    blocTest<LoginScreenBloc, LoginScreenEvent, LoginScreenState>(
      'should emit SignedIn when provided valid credentials',
      build: () {
        when(userRepository.signIn(email: email, password: password)).thenAnswer((_) => Future.value(session));
        return loginScreenBloc;
      },
      act: (LoginScreenBloc bloc) async => bloc.add(
        const SignIn(email: email, password: password),
      ),
      expect: <LoginScreenState>[
        const NotSignedIn(),
        const SigningIn(),
        const SignedIn(session),
      ],
    );

    const error = 'Invalid password';
    blocTest<LoginScreenBloc, LoginScreenEvent, LoginScreenState>(
      'should emit NotSignedIn with error when provided invalid credentials',
      build: () {
        when(userRepository.signIn(email: email, password: password))
            .thenThrow(const InvalidCredentialsException(error));
        return loginScreenBloc;
      },
      act: (LoginScreenBloc bloc) async => bloc.add(
        const SignIn(email: email, password: password),
      ),
      expect: <LoginScreenState>[
        const NotSignedIn(),
        const SigningIn(),
        const NotSignedIn(error: error),
      ],
    );
  });
}
