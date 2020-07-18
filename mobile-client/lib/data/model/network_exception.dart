class NoConnectionException implements Exception {}

class HttpException implements Exception {
  final int statusCode;
  const HttpException(this.statusCode);
}

class UnauthorizedRequestException extends HttpException {
  final Map<dynamic, dynamic> body;
  const UnauthorizedRequestException(int statusCode, this.body) : super(statusCode);
}

class BadRequestException extends HttpException {
  final Map<dynamic, dynamic> body;
  const BadRequestException(int statusCode, this.body) : super(statusCode);
}
