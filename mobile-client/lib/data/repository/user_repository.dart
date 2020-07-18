import 'package:meta/meta.dart';
import 'package:quantifico/data/model/auth/session.dart';
import 'package:quantifico/data/model/network_exception.dart';
import 'package:quantifico/data/provider/token_local_provider.dart';
import 'package:quantifico/data/provider/user_local_provider.dart';
import 'package:quantifico/util/web_client.dart';

class InvalidCredentialsException implements Exception {
  final String error;
  const InvalidCredentialsException(this.error);
}

class UserRepository {
  final WebClient webClient;
  final TokenLocalProvider tokenLocalProvider;
  final UserLocalProvider userLocalProvider;

  UserRepository({
    @required this.webClient,
    @required this.tokenLocalProvider,
    @required this.userLocalProvider,
  });

  Future<Session> signIn({
    String email,
    String password,
  }) async {
    try {
      final jsonBody = await webClient.post(
        'sessao',
        body: {'email': email, 'senha': password},
      ) as Map<dynamic, dynamic>;

      final session = Session.fromJson(jsonBody);
      tokenLocalProvider.setToken(session.token);
      userLocalProvider.setUser(session.user);
      return session;
    } catch (e) {
      if (e is UnauthorizedRequestException || e is BadRequestException) {
        final msg = e.body['errors'][0]['messages'][0] as String;
        throw InvalidCredentialsException(msg);
      } else {
        rethrow;
      }
    }
  }

  Future<bool> isAuthenticated() async {
    return tokenLocalProvider.hasValidToken();
  }

  Future<Session> getSession() async {
    final token = await tokenLocalProvider.getToken();
    final user = userLocalProvider.getUser();

    return Session(user: user, token: token);
  }

  Future<void> signOut() async {
    tokenLocalProvider.clearToken();
    userLocalProvider.clearUser();
  }
}
