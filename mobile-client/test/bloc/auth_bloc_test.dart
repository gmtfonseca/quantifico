import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quantifico/bloc/auth/barrel.dart';
import 'package:quantifico/data/model/auth/session.dart';
import 'package:quantifico/data/model/auth/user.dart';
import 'package:quantifico/data/repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  const TOKEN =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVkZTZmMjUwZjI3OTI2M2I0OGJhNWYyYiIsIm9yZ2FuaXphY2FvIjoiNWRlNmYyND'
      'FmMjc5MjYzYjQ4YmE1ZjJhIiwiaWF0IjoxNTkwMjY2Mzc4LCJleHAiOjE1OTAzNTI3Nzh9.SBIx1wWespyhl2YaeOukjmKaAdXBn0z94bu4gSXh0qw';

  group('AuthBloc', () {
    UserRepository userRepository;
    AuthBloc authBloc;

    setUp(() {
      userRepository = MockUserRepository();
      authBloc = AuthBloc(userRepository: userRepository);
    });

    const session = Session(
      user: User(email: 'john@doe', name: 'John Doe'),
      token: TOKEN,
    );

    blocTest<AuthBloc, AuthEvent, AuthState>(
      'should emit Authenticated when successfully sign in',
      build: () => authBloc,
      act: (AuthBloc bloc) async => bloc.add(
        const Authenticate(session: session),
      ),
      expect: <AuthState>[
        const Authenticating(),
        const Authenticated(session),
      ],
    );

    blocTest<AuthBloc, AuthEvent, AuthState>(
      'should emit Authenticated when there is a valid session',
      build: () {
        when(userRepository.isAuthenticated()).thenAnswer((_) => Future.value(true));
        when(userRepository.getSession()).thenAnswer((_) => Future.value(session));
        return authBloc;
      },
      act: (AuthBloc bloc) async => bloc.add(const CheckAuthentication()),
      expect: <AuthState>[
        const Authenticating(),
        const Authenticated(session),
      ],
    );

    blocTest<AuthBloc, AuthEvent, AuthState>(
      'should emit NotAuthenticated when there is no valid session',
      build: () {
        when(userRepository.isAuthenticated()).thenAnswer((_) => Future.value(false));
        return authBloc;
      },
      act: (AuthBloc bloc) async => bloc.add(const CheckAuthentication()),
      expect: <AuthState>[
        const Authenticating(),
        const NotAuthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthEvent, AuthState>(
      'should emit NotAuthenticated when sign out',
      build: () => authBloc,
      act: (AuthBloc bloc) async => bloc.add(const DeAuthenticate()),
      expect: <AuthState>[
        const Authenticating(),
        const NotAuthenticated(),
      ],
    );
  });
}
