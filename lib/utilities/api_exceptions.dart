class ApiException implements Exception {
  final String? message;
  ApiException([this.message]);
}

class BadRequestException extends ApiException {
  BadRequestException([super.message]);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([super.message]);
}

class ForbiddenException extends ApiException {
  ForbiddenException([super.message]);
}

class NotFoundException extends ApiException {
  NotFoundException([super.message]);
}

class ServerException extends ApiException {
  ServerException([super.message]);
}

class TimeoutException extends ApiException {
  TimeoutException([super.message]);
}

class RequestCancelledException extends ApiException {
  RequestCancelledException([super.message]);
}
