import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../../features/common/helper/view_toolbox.dart';
import '../../features/di/dependency_init.dart';
import '../../features/shared/common_utils/log_utils.dart';
import '../../features/shared/data/local_data.dart';
import 'api/network_apis_constants.dart';

///Header management interceptor
class AuthInterceptor extends Interceptor {
  final Dio _dio = getIt<Dio>();

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final PingData resultPing = await Ping('google.com', count: 1).stream.first;

    List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      ViewsToolbox.dismissLoading();
      handler.reject(err);
      return;
    } else if (result.first == ConnectivityResult.none) {
      ViewsToolbox.dismissLoading();
      handler.reject(err);
      return;
    } else if (result.first != ConnectivityResult.none &&
        resultPing.response?.ttl == null) {
      ViewsToolbox.dismissLoading();
      handler.reject(err);
      return;
    } else if (err.response?.statusCode == 429) {
      _dio.interceptors.clear();
      _dio.interceptors.addAll(<Interceptor>[
        AuthInterceptor(),
        if (kDebugMode) LoggingInterceptor(),
      ]);

      handler.resolve(await _dio.fetch(err.requestOptions));

      return;
    } else if ((err.response == null) ||
        (err.response?.data == "") ||
        err.response?.statusCode == 401) {
      //TODO: use refresh token or generate new login token .
      try {
        ViewsToolbox.dismissLoading();
        handler.reject(err);
        FirebaseCrashlytics.instance.recordError(err, null,
            reason: "Dio Exp \nerr:${err.requestOptions.path}\n");
        return;
      } catch (e) {
        FirebaseCrashlytics.instance.recordError(e, null,
            reason: "Dio Exp \nerr:${err.requestOptions.path}\n");
        ViewsToolbox.dismissLoading();
        return;
      }
    }
    ViewsToolbox.dismissLoading();
    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
  

    
    //  options.headers["Content-Type"] = "application/json";
    options.headers["Accept"] = "application/json";
    options.headers["Content-Type"] = "application/json";
    options.headers["Connection"] = "keep-alive";

    // if (options.headers["x-api-key"] == null) {
    //   options.headers["mobKey"] =
    //       "D9GVHLI49G+ZNuv5ScCE3HKfaasvzX0bR7TAqQzuXeO3hRlZd2+d3KF6o8fiLevyKTk3zHkScdT+3wB1YdByN3kxoxSleSRdEX6fPKTcLiJFhWw36YkoRsCbqFzwkZl4XqS6cZut0ujISvFLixwG4pKkZQOo/Sz9tscKl8RmLKZVgIrtqlR3cH5AHFtro9ik+VYU7HytQQ8Bfvs2x9kD3uQX3JaZjKa+Gk5TzyNmLqxm+zLK5Tu6zWz5jGyJit/Eav+SMqPHR2p+Ayt2zcafo+hQOhgADbgsHfzx62PQeqAr4XxriPIgkqxdUPPi77SyQN0CADCE83M=";
    // }

    handler.next(options);
  }
}

///Log interceptor settings
class LoggingInterceptor extends Interceptor {
  DateTime? startTime;
  DateTime? endTime;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Log.e("--------------Error-----------");
    handler.reject(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    startTime = DateTime.now();
    Log.d("----------Request Start---------");
    Log.i(" path :${options.path}");

    // if(options.path.contains(Api.getCountriesListApiCall)){
    //   options.baseUrl=Api.nartaqiBaseUrl;
    // }

    ///print full path request
    if (options.queryParameters.isEmpty) {
      if (options.path.contains(options.baseUrl)) {
        Log.i("RequestUrl:${options.path}");
      } else {
        Log.i("RequestUrl:${options.baseUrl}${options.path}");
      }
    } else {
      ///If queryParameters is not empty, splice into a complete URl
      Log.i(
        "RequestUrl:${options.baseUrl}${options.path}?${Transformer.urlEncodeMap(options.queryParameters)}",
      );
    }

    Log.w("RequestMethod:${options.method}");
    Log.w("RequestHeaders:${options.headers}");
    Log.w("RequestContentType:${options.contentType}");
    Log.w("RequestDataOptions:${options.data}");

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    endTime = DateTime.now();
    //Request duration
    final int duration = endTime!.difference(startTime!).inMilliseconds;
    Log.i("----------End Request $duration millisecond---------");

    super.onResponse(response, handler);
  }
}

//parsing data
