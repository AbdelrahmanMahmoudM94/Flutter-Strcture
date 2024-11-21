import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../features/common/helper/view_toolbox.dart';
import '../../../features/di/dependency_init.dart';
import '../../../features/routes/routes.dart';
import 'error_status.dart';

class ExceptionHandle {
  static String globalError =
      getIt<AppRouter>().navigatorKey.currentContext!.tr("general-error");

  static NetError handleException(dynamic error) {
    ViewsToolbox.dismissLoading();

    if (error is DioException) {
      if (error.type == DioExceptionType.unknown ||
          error.type == DioExceptionType.badResponse) {
        final dynamic e = error.error;

        ///网络异常
        if (e is SocketException) {
          return NetError(ErrorStatus.SOCKET_ERROR, globalError);
        }

        ///服务器异常`
        if (e is HttpException) {
          return NetError(ErrorStatus.SERVER_ERROR, globalError);
        }
        //默认返回网络异常
        return NetError(ErrorStatus.NETWORK_ERROR, globalError);

        ///各种超时
      } else if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return NetError(ErrorStatus.TIMEOUT_ERROR, globalError);

        ///取消请求操作
      } else if (error.type == DioExceptionType.cancel) {
        return NetError(ErrorStatus.CANCEL_ERROR, "");

        //其他异常
      } else {
        return NetError(ErrorStatus.UNKNOWN_ERROR, globalError);
      }
    } else {
      return NetError(ErrorStatus.UNKNOWN_ERROR, globalError);
    }
  }
}

class NetError {
  NetError(this.code, this.msg);
  int code;
  String msg;
}
