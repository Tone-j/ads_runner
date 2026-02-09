class ServerException implements Exception {
  final String message;
  final int? code;
  const ServerException({this.message = 'Server error', this.code});
}

class CacheException implements Exception {
  final String message;
  const CacheException({this.message = 'Cache error'});
}

class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException({this.message = 'Unauthorized'});
}
