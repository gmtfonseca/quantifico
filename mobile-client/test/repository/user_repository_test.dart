import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quantifico/data/model/auth/session.dart';
import 'package:quantifico/data/model/auth/user.dart';
import 'package:quantifico/data/repository/user_repository.dart';

import '../mocks.dart';

void main() {
  const TOKEN =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVkZTZmMjUwZjI3OTI2M2I0OGJhNWYyYiIsIm9yZ2FuaXphY2FvIjoiNWRlNmYyND'
      'FmMjc5MjYzYjQ4YmE1ZjJhIiwiaWF0IjoxNTkwMjY2Mzc4LCJleHAiOjE1OTAzNTI3Nzh9.SBIx1wWespyhl2YaeOukjmKaAdXBn0z94bu4gSXh0qw';

  group('Auth Repository', () {
    final webClient = MockWebClient();
    final userlocalProvider = MockUserLocalProvider();
    final tokenLocalProvider = MockTokenLocalProvider();
    final userRepository = UserRepository(
      webClient: webClient,
      userLocalProvider: userlocalProvider,
      tokenLocalProvider: tokenLocalProvider,
    );

    test('should signin properly', () async {
      const email = 'john@doe';
      const password = 'doe';

      when(
        webClient.post('sessao', body: {
          'email': email,
          'senha': password,
        }),
      ).thenAnswer(
        (_) => Future<dynamic>.value(
          {
            'usuario': {
              'organizacao': '1',
              'nome': 'John',
              'email': 'john@doe',
            },
            'token': TOKEN,
          },
        ),
      );
      final data = await userRepository.signIn(
        email: email,
        password: password,
      );
      expect(
        data,
        const Session(
          user: User(
            name: 'John',
            email: 'john@doe',
          ),
          token: TOKEN,
        ),
      );
    });

    test('should get session properly', () async {
      const user = User(email: 'john@doe', name: 'John Doe');
      when(userlocalProvider.getUser()).thenReturn(user);
      when(tokenLocalProvider.getToken()).thenAnswer((_) => Future.value(TOKEN));

      final session = await userRepository.getSession();

      expect(
        session,
        const Session(user: user, token: TOKEN),
      );
    });

    test('should signout properly', () async {
      await userRepository.signOut();
      verify(userlocalProvider.clearUser()).called(1);
      verify(tokenLocalProvider.clearToken()).called(1);
    });
  });
}
