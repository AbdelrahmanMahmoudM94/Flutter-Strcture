import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
 import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_structure/core/network/auth_retry_policy.dart';

import '../../features/common/helper/view_toolbox.dart';
import '../../features/di/dependency_init.dart';
import '../../features/shared/data/local_data.dart';
import 'api/network_apis_constants.dart';

///Header management interceptor
class AuthInterceptor extends Interceptor {
  final Dio _dio = getIt<Dio>();
  final AuthRetryPolicy _retryPolicy = AuthRetryPolicy();
  static const String _authRetriedKey = 'auth_retried_after_refresh';

  /// Shared by all requests that hit a 401 while a refresh is in flight.
  /// Completes with the new token, or "" if the session could not be renewed.
  Completer<String>? _refreshTokenCompleter;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    //  options.headers["Content-Type"] = "application/json";
    // options.headers["Accept"] = "application/json";
    if (!options.headers.containsKey("Content-Type")) {
      options.headers["Content-Type"] = "application/json";
    }
    String? token = "";

    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
    }
    options.headers["Connection"] = "keep-alive";

    //options.headers["DeviceId"] = "123444";

    // if (options.headers["x-api-key"] == null) {
    //   options.headers["mobKey"] =
    //       "D9GVHLI49G+ZNuv5ScCE3HKfaasvzX0bR7TAqQzuXeO3hRlZd2+d3KF6o8fiLevyKTk3zHkScdT+3wB1YdByN3kxoxSleSRdEX6fPKTcLiJFhWw36YkoRsCbqFzwkZl4XqS6cZut0ujISvFLixwG4pKkZQOo/Sz9tscKl8RmLKZVgIrtqlR3cH5AHFtro9ik+VYU7HytQQ8Bfvs2x9kD3uQX3JaZjKa+Gk5TzyNmLqxm+zLK5Tu6zWz5jGyJit/Eav+SMqPHR2p+Ayt2zcafo+hQOhgADbgsHfzx62PQeqAr4XxriPIgkqxdUPPi77SyQN0CADCE83M=";
    // }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.response?.statusCode == 500 ||
        (err.response?.statusCode != null &&
            (err.response?.statusCode)! > 500) ||
        err.response?.statusCode == 503 ||
        err.response?.statusCode == 400 ||
        err.response?.statusCode == 404) {
      ViewsToolbox.dismissLoading();
      handler.reject(err);
      return;
    } else if (result.first == ConnectivityResult.none) {
      ViewsToolbox.dismissLoading();
      handler.reject(err);
      return;
    } else if (err.response?.statusCode == 429) {
      if (!_retryPolicy.shouldRetryTooManyRequests(err.requestOptions)) {
        ViewsToolbox.dismissLoading();
        handler.reject(err);
        return;
      }

      _retryPolicy.markTooManyRequestsRetry(err.requestOptions);

      // A 429 means the quota is already exhausted, so replaying immediately
      // would only burn the single allowed retry. Honour `Retry-After` when
      // the server sends it, otherwise back off exponentially with jitter.
      final Duration retryDelay = _retryPolicy.retryDelayFor(err);
      if (retryDelay > Duration.zero) {
        await Future<void>.delayed(retryDelay);
      }

      try {
        handler.resolve(await _dio.fetch(err.requestOptions));
      } on DioException catch (retryErr) {
        ViewsToolbox.dismissLoading();
        handler.reject(retryErr);
      }
      return;
    } else if (err.response?.statusCode == 401) {
      final RequestOptions options = err.requestOptions;

      if (options.extra[_authRetriedKey] != true) {
        // final String token = await _getFreshToken(options);
        // if (token.isEmpty) {
        //   handler.reject(err);
        //   return;
        // }
        // options.headers["Authorization"] = "Bearer $token";
        // options.extra[_authRetriedKey] = true;
        // try {
        //   handler.resolve(await _dio.fetch(options));
        // } on DioException catch (retryErr) {
        //   handler.reject(retryErr);
        // }
        // return;
      }
    }
    FirebaseCrashlytics.instance.recordError(
      err,
      null,
      reason: "Dio Exp "
          "\n"
          "err:${err.requestOptions.path}"
          "\n",
    );

    handler.next(err);
  }

  /// Returns a valid token for replaying [failed]. Only the first 401 triggers
  /// a refresh; parallel 401s await that same refresh instead of failing.
  // Future<String> _getFreshToken(RequestOptions failed) async {
  //   final Completer<String>? pending = _refreshTokenCompleter;
  //   if (pending != null) {
  //     return pending.future;
  //   }

  //   final String? current = LocalData.getAzureToken();
  //   if (current != null &&
  //       failed.headers["Authorization"] != "Bearer $current") {
  //     return current;
  //   }

  //   final Completer<String> completer = _refreshTokenCompleter =
  //       Completer<String>();
  //   String token = "";
  //   try {
  //     final String? expDate = LocalData.getAzureTokenDate();
  //     if (expDate != null && DateTime.now().isBefore(DateTime.parse(expDate))) {
  //       token = await refreshToken(LocalData.getAzureToken()!, failed);
  //     }
  //     if (token.isNotEmpty) {
  //       LocalData.setToken(token);
  //     } else {
  //       await IsarHelper.deleteIsarDatabase();
  //       CustomMainRouter.push(LoginRoute());
  //     }
  //   } catch (_) {
  //     token = "";
  //   } finally {
  //     _refreshTokenCompleter = null;
  //     completer.complete(token);
  //   }
  //   return token;
  // }

  // Future<String> refreshToken(
  //   String refreshToken,
  //   RequestOptions requestOptions,
  // ) async {
  //   String token = "";
  //   try {
  //     final Response response = await _dio.post(
  //       ApiConstants.refreshToken,
  //       data: {"refreshToken": refreshToken},
  //     );
  //     if (!(response.statusCode == 200)) {
  //       return token;
  //     }

  //     final LoginResponseModel json = LoginResponseModel.fromJson(
  //       response.data,
  //     );

  //     if (json.token != null && json.token != "") {
  //       token = json.token!;
  //       LocalData.setRefreshToken(json.refreshToken!);
  //       LocalData.setRefreshTokenExpDate(json.refreshTokenExpiry!);
  //       // await getIt<LoggedInChatSocketCubit>().forceConnectSocket();
  //     }

  //     return token;
  //   } on DioException catch (e) {
  //     return token;
  //   }
  // }
}

///Request content-type defaults
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.contentType == null) {
      final dynamic data = options.data;
      final String? contentType;
      if (data is FormData) {
        contentType = Headers.multipartFormDataContentType;
      } else if (data is Map) {
        contentType = Headers.formUrlEncodedContentType;
      } else if (data is String) {
        contentType = Headers.jsonContentType;
      } else if (data != null) {
        contentType =
            Headers.textPlainContentType; // Can be removed if unnecessary.
      } else {
        contentType = null;
      }
      options.contentType = contentType;
    }
    super.onRequest(options, handler);
  }
}

//parsing data
