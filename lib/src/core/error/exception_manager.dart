import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tarsheed/src/core/error/custom_exceptions/auth_exceptions.dart';
import 'package:tarsheed/src/core/error/handlers/auth_exception_handler.dart';
import 'package:tarsheed/src/core/error/handlers/dio_exception_handler.dart';
import 'package:tarsheed/src/core/error/handlers/sqflite_exception_handler.dart';
import 'package:tarsheed/src/core/error/handlers/unexpected_exception_handler.dart';
import 'package:tarsheed/src/core/utils/theme_manager.dart';

abstract class ExceptionHandler {
  String handle(Exception exception);
  String getIconPath(Exception exception);
}

class ExceptionManager {
  static final Map<Type, ExceptionHandler> _handlers = <Type, ExceptionHandler>{
    DioException: DioExceptionHandler(),
    AuthException: AuthExceptionHandler(),
    UnexpectedExceptionHandler: UnexpectedExceptionHandler(),
    DatabaseException: SQLiteExceptionHandler(),
  };

  static String getMessage(Exception exception) {
    return _handlers[exception.runtimeType]?.handle(exception) ??
        _handlers[UnexpectedExceptionHandler]!.handle(exception);
  }

  static String getIconPath(Exception exception) {
    return _handlers[exception.runtimeType]?.getIconPath(exception) ??
        _handlers[UnexpectedExceptionHandler]!.getIconPath(exception);
  }

  static void showMessage(Exception exception) {
    Fluttertoast.showToast(
        msg: getMessage(exception), backgroundColor: ThemeManager.dangerRed);
  }
}
