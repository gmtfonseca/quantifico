import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:quantifico/config.dart';
import 'package:quantifico/data/model/network_exception.dart';

class WebClient {
  final String baseUrl;
  Map<String, String> _headers;

  WebClient([this.baseUrl = NetworkConfig.baseUrl]) {
    _headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
  }

  Future<dynamic> fetch(
    String endpoint, {
    Map<String, String> params,
    Map<String, String> headers,
  }) async {
    try {
      final uri = Uri.http(
        baseUrl,
        endpoint,
        params,
      );
      final response = await http.get(
        uri,
        headers: {}..addAll(_headers)..addAll(headers ?? {}),
      );

      return _handleResponse(response);
    } on SocketException {
      throw NoConnectionException();
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, String> body,
    Map<String, String> params,
    Map<String, String> headers,
  }) async {
    try {
      final uri = Uri.http(
        baseUrl,
        endpoint,
        params,
      );
      final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: {}..addAll(_headers)..addAll(headers ?? {}),
      );

      return _handleResponse(response);
    } on SocketException {
      throw NoConnectionException();
    } catch (e) {
      rethrow;
    }
  }

  dynamic _handleResponse(http.Response response) {
    dynamic body;
    if (response.body != null) {
      body = jsonDecode(response.body);
    }
    switch (response.statusCode) {
      case HttpStatus.ok:
        return body;
      case HttpStatus.badRequest:
        throw BadRequestException(response.statusCode, body as Map<dynamic, dynamic>);
      case HttpStatus.unauthorized:
        throw UnauthorizedRequestException(response.statusCode, body as Map<dynamic, dynamic>);
      default:
        throw HttpException(response.statusCode);
    }
  }
}
