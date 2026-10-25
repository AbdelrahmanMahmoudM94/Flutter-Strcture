import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
  
class AuthRetryPolicy {
  static const String tooManyRequestsRetryCountKey =
      'auth_too_many_requests_retry_count';

  /// Hard ceiling on how long a single request may be held back, even if the
  /// server asks for longer. Without this a hostile or buggy
  /// `Retry-After: 86400` would freeze the request and its loading indicator
  /// for a whole day.
  static const Duration maxRetryDelay = Duration(seconds: 30);

  /// Backoff used when the server does not send `Retry-After`.
  static const Duration baseRetryDelay = Duration(seconds: 2);

  /// Highest exponent used for the backoff. `2^6 * 2s = 128s`, well past
  /// [maxRetryDelay], so the clamp is what actually bounds the wait.
  static const int _maxBackoffExponent = 6;

  static final Set<String> _nonRetryablePaths = <String>{
    // ApiConstants.refreshToken,
    // ApiConstants.login,
  };

  final Random _random = Random();

  bool shouldRetryTooManyRequests(RequestOptions options) {
    if (_nonRetryablePaths.contains(options.path)) {
      return false;
    }

    return _retryCount(options) < 1;
  }

  void markTooManyRequestsRetry(RequestOptions options) {
    options.extra[tooManyRequestsRetryCountKey] = _retryCount(options) + 1;
  }

  /// How long to wait before replaying the request that failed with [error].
  ///
  /// Prefers the server's `Retry-After` header, which may be either
  /// delta-seconds (`Retry-After: 120`) or an HTTP-date
  /// (`Retry-After: Wed, 21 Oct 2015 07:28:00 GMT`). Values already in the
  /// past collapse to [Duration.zero]. Unparseable values fall back to
  /// jittered exponential backoff.
  ///
  /// The result is always within `[Duration.zero, maxRetryDelay]`.
  Duration retryDelayFor(DioException error) {
    final Duration? serverDelay = _parseRetryAfter(error.response);
    final Duration delay =
        serverDelay ?? _backoffWithJitter(_retryCount(error.requestOptions));
    if (delay.isNegative) {
      return Duration.zero;
    }
    return delay > maxRetryDelay ? maxRetryDelay : delay;
  }

  Duration? _parseRetryAfter(Response<dynamic>? response) {
    final Object? raw = response?.headers.value('Retry-After');
    if (raw == null) {
      return null;
    }
    final String value = raw.toString().trim();
    if (value.isEmpty) {
      return null;
    }

    final int? seconds = int.tryParse(value);
    if (seconds != null) {
      return Duration(seconds: seconds < 0 ? 0 : seconds);
    }

    final DateTime? date = _parseHttpDate(value);
    if (date == null) {
      return null;
    }
    final Duration remaining = date.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  DateTime? _parseHttpDate(String value) {
    try {
      return HttpDate.parse(value);
    } on HttpException {
      return DateTime.tryParse(value)?.toUtc();
    } on FormatException {
      return DateTime.tryParse(value)?.toUtc();
    }
  }

  /// "Equal jitter" backoff: waits a random duration in
  /// `[delay / 2, delay]`. The randomness keeps many clients from replaying
  /// simultaneously, while the floor keeps the wait meaningful.
  Duration _backoffWithJitter(int attempt) {
    final int exponent = attempt.clamp(0, _maxBackoffExponent);
    final int ceiling = min(
      baseRetryDelay.inMilliseconds * (1 << exponent),
      maxRetryDelay.inMilliseconds,
    );
    final int half = ceiling ~/ 2;
    return Duration(milliseconds: half + _random.nextInt(half + 1));
  }

  int _retryCount(RequestOptions options) {
    final Object? retryCount = options.extra[tooManyRequestsRetryCountKey];
    return retryCount is int ? retryCount : 0;
  }
}
