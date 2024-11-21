import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../di/dependency_init.dart';
import 'routes.dart';

class CustomMainRouter {
  static final AppRouter appRouter = getIt<AppRouter>();

  static void navigate(PageRouteInfo route,
      {FutureOr<dynamic> Function(Object?)? then}) {
    appRouter.navigate(route).then(then ?? (Object? value) {});
  }

  static void pop() {
    Navigator.pop(getIt<AppRouter>().navigatorKey.currentContext!);
  }

  static void push(PageRouteInfo route,
      {FutureOr<dynamic> Function(Object?)? then}) {
    appRouter.push(route).then(then ?? (Object? value) {});
  }

  static void pushAndPopUntil(PageRouteInfo route) {
    appRouter.pushAndPopUntil(route,
        predicate: (Route<dynamic> route) => false);
  }
}
