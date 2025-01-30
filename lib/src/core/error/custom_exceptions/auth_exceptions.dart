import 'package:dio/dio.dart';
import 'package:tarsheed/src/core/error/handlers/auth_exception_handler.dart';

/// This class is used to handle exceptions related to authentication with custom messages
/// the handler will be used is [AuthExceptionHandler]
class AuthException extends DioException {
  AuthException({required super.requestOptions});
}
