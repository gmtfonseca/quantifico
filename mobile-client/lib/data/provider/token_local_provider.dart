import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenLocalProvider {
  final FlutterSecureStorage storage;
  static const accessKey = 'token';

  const TokenLocalProvider({this.storage});

  Future<bool> hasValidToken() async {
    final token = await getToken();
    if (token == null) {
      return false;
    }

    final tokenParts = token.split('.');
    final payload = json.decode(ascii.decode(base64.decode(base64.normalize(tokenParts[1])))) as Map<dynamic, dynamic>;
    final expDateInSeconds = payload['exp'] as int;

    return DateTime.fromMillisecondsSinceEpoch(expDateInSeconds * 1000).isAfter(DateTime.now());
  }

  void setToken(String token) {
    storage.write(key: accessKey, value: token);
  }

  void clearToken() {
    storage.delete(key: accessKey);
  }

  Future<String> getToken() async {
    final token = await storage.read(key: 'token');
    return token;
  }
}
