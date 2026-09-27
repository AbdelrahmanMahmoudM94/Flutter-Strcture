import 'dart:async';
import 'dart:convert';
import 'dart:developer';

 import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
 
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_structure/features/di/dependency_init.dart';
import 'package:injectable/injectable.dart';
  
import '../../features/shared/data/local_data.dart';
import 'exception/exception_handle.dart';
import 'interceptors.dart';

enum Method { get, post, put, delete }

@injectable
class NetworkHelper {
  NetworkHelper(this.dio) {
    dio.interceptors.clear();
    dio.interceptors.addAll(<Interceptor>[
      AuthInterceptor(),
      if (kDebugMode) LoggingInterceptor(),
      if (kDebugMode) CurlLoggerDioInterceptor(printOnSuccess: true),
    ]);

    // if (kDebugMode) {
    //   dio.interceptors.add(LoggingInterceptor());
    // }
    // _dio.interceptors.add(MyInterceptor());
  }
  final Dio dio;
  LocalData localData = LocalData();
   Future<Response> delete({
    required String path,
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    final Map<String, dynamic> tmpHeaders = _constructTheHeaders(headers);

    try {
      final Map<String, dynamic> tmpHeaders = _constructTheHeaders(headers);

      final Response response = await dio.delete(
        path,
        data: data,
        options: Options(
          headers: tmpHeaders,
          receiveTimeout: const Duration(seconds: 100),
          sendTimeout: const Duration(seconds: 100),
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<({dynamic response, bool success})> get({
    required String path,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    bool disableInterceptors = false,
    ResponseType? responseType,
  }) async {
    try {
      if (disableInterceptors) {
        dio.interceptors.clear();
      }

      final Response response = await dio.get(
        path,
        queryParameters: queryParams
          ?..removeWhere((String key, value) => value == null),
        options: Options(
          responseType: responseType,
          headers: headers,
          receiveTimeout: const Duration(seconds: 100),
          sendTimeout: const Duration(seconds: 100),
        ),
      );

      if (response.statusCode == 200) {
        return (response: response.data, success: true);
      } else {
        return (response: response.data['data']['message'], success: false);
      }
    } on DioException catch (e) {
      NetError netError = ExceptionHandle.handleException(e);
      return (response: netError.msg, success: false);
    }
  }

  Future<({dynamic response, bool success})> post({
    required String path,
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
    bool disableInterceptors = false,
    bool saveCookie = false,
    bool removeCookie = false,
    int? seconds,
    ResponseType? resonseType,
    void Function(int, int)? onSendProgress,
    bool? responseOnly,
    bool? handleCustomError = false,
    bool useCancelToken = true,
  }) async {
    try {
      if (disableInterceptors) {
        dio.interceptors.clear();
      }
      if (saveCookie) {
        //  dio.interceptors.add(CookieManager(cookieJar));
      }
      if (removeCookie) {
        dio.interceptors.clear();
        dio.interceptors.addAll(<Interceptor>[
          AuthInterceptor(),
          if (kDebugMode) LoggingInterceptor(),
        ]);
      }

      // final Map<String, dynamic> tmpHeaders = _constructTheHeaders(headers);
      Response<dynamic> result;
      // queryParams?.removeWhere((String key, value) => value == null);
      if (data != null) {
        if (data.runtimeType == List<Map<String, dynamic>>) {
          (data as List<Map<String, dynamic>>?)!.map(
            (Map<String, dynamic> e) =>
                e.removeWhere((String key, value) => value == null),
          );
        } else {
          if (data is Map<String, dynamic>) {
            data.removeWhere((String key, value) => value == null);
          }
        }
      }

      final Response response = await dio.post(
        path,
        onSendProgress: onSendProgress,
        data: data,
        cancelToken: useCancelToken ? getIt<CancelToken>() : null,
        queryParameters: queryParams
          ?..removeWhere((String key, value) => value == null),
        options: Options(
          headers: headers,
          responseType: resonseType,
          receiveTimeout: Duration(seconds: seconds ?? 100),
          sendTimeout: Duration(seconds: seconds ?? 100),
        ),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        return (response: response.data, success: true);
      } else {
        inspect(response.data);
        if (response.data['data']['message'] == null) {
          return (response: response.data, success: false);
        }
        return (response: response.data['data']['message'], success: false);
      }
    } on DioException catch (e) {
   
     
      NetError netError = ExceptionHandle.handleException(
        e,
        handleCustomError: handleCustomError,
      );
      return (response: netError.msg, success: false);
    }
  }

  Future<({dynamic response, bool success})> put({
    required String path,
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
    bool disableInterceptors = false,
    bool saveCookie = false,
    bool removeCookie = false,
    int? seconds,
    ResponseType? resonseType,
    void Function(int, int)? onSendProgress,
    bool? responseOnly,
    bool useCancelToken = true,
  }) async {
    try {
      if (disableInterceptors) {
        dio.interceptors.clear();
      }
      if (saveCookie) {
        //  dio.interceptors.add(CookieManager(cookieJar));
      }
      if (removeCookie) {
        dio.interceptors.clear();
        dio.interceptors.addAll(<Interceptor>[
          AuthInterceptor(),
          if (kDebugMode) LoggingInterceptor(),
        ]);
      }

      // final Map<String, dynamic> tmpHeaders = _constructTheHeaders(headers);
      Response<dynamic> result;
      // queryParams?.removeWhere((String key, value) => value == null);
      if (data != null) {
        if (data.runtimeType == List<Map<String, dynamic>>) {
          (data as List<Map<String, dynamic>>?)!.map(
            (Map<String, dynamic> e) =>
                e.removeWhere((String key, value) => value == null),
          );
        } else {
          if (data is Map<String, dynamic>) {
            data.removeWhere((String key, value) => value == null);
          }
        }
      }

      final Response response = await dio.put(
        path,
        onSendProgress: onSendProgress,
        data: data,
        cancelToken: useCancelToken ? getIt<CancelToken>() : null,
        queryParameters: queryParams
          ?..removeWhere((String key, value) => value == null),
        options: Options(
          headers: headers,
          responseType: resonseType,
          receiveTimeout: Duration(seconds: seconds ?? 100),
          sendTimeout: Duration(seconds: seconds ?? 100),
        ),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        return (response: response.data, success: true);
      } else {
        inspect(response.data);
        if (response.data['data']['message'] == null) {
          return (response: response.data, success: false);
        }
        return (response: response.data['data']['message'], success: false);
      }
    } on DioException catch (e) {
      NetError netError = ExceptionHandle.handleException(e);
      return (response: netError.msg, success: false);
    }
  }

  Stream<String> postStream({
    required String path,
    dynamic data,
    Map<String, dynamic>? headers,
  }) {
    StreamSubscription<List<int>>? innerSubscription;
    final controller = StreamController<String>(
      onCancel: () {
        innerSubscription?.cancel();
      },
    );

    () async {
      try {
        if (data != null && data is Map<String, dynamic>) {
          data.removeWhere((String key, value) => value == null);
        }

        final Response response = await dio.post(
          path,
          data: data,
          cancelToken: getIt<CancelToken>(),
          options: Options(
            headers: headers,
            responseType: ResponseType.stream,
            receiveTimeout: const Duration(minutes: 5),
            sendTimeout: const Duration(seconds: 100),
          ),
        );

        final ResponseBody responseBody = response.data as ResponseBody;
        String buffer = '';

        innerSubscription = responseBody.stream.listen(
          (List<int> chunk) {
            buffer += utf8.decode(chunk, allowMalformed: true);
            final lines = buffer.split('\n');
            buffer = lines.removeLast();

            for (final line in lines) {
              print(line);
              final trimmed = line.trim();
              if (trimmed.isEmpty || trimmed.startsWith(':')) continue;
              if (trimmed.startsWith('event:')) continue;
              if (trimmed.startsWith('id:')) continue;
              if (trimmed.startsWith('retry:')) continue;

              String jsonData;
              if (trimmed.startsWith('data:')) {
                jsonData = trimmed.substring(5).trim();
              } else {
                jsonData = trimmed;
              }

              if (jsonData.isNotEmpty && jsonData != '[DONE]') {
                controller.add(jsonData);
              }
            }
          },
          onDone: () {
            if (buffer.trim().isNotEmpty) {
              final trimmed = buffer.trim();
              if (!trimmed.startsWith(':') &&
                  !trimmed.startsWith('event:') &&
                  !trimmed.startsWith('id:') &&
                  !trimmed.startsWith('retry:')) {
                String jsonData;
                if (trimmed.startsWith('data:')) {
                  jsonData = trimmed.substring(5).trim();
                } else {
                  jsonData = trimmed;
                }
                if (jsonData.isNotEmpty && jsonData != '[DONE]') {
                  controller.add(jsonData);
                }
              }
            }
            controller.close();
          },
          onError: (error) {
            controller.addError(error);
            controller.close();
          },
          cancelOnError: false,
        );
      } catch (e) {
        controller.addError(e);
        controller.close();
      }
    }();

    return controller.stream;
  }

  Map<String, dynamic> _constructTheHeaders(Map<String, dynamic>? headers) {
    Map<String, dynamic> tmpHeaders = <String, dynamic>{
      'Content-type': 'application/json',
      'Accept': 'text/plain',
      'connection': 'keep-alive',
    };
    if (headers != null) {
      tmpHeaders = headers;
    }
    // final String? mobKey = LocalData.getMobKey();

    // if (mobKey != null) {
    //   tmpHeaders["mobKey"] = "$mobKey";
    // }

    return tmpHeaders;
  }
}
