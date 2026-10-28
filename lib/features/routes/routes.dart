import 'package:auto_route/auto_route.dart';
import 'package:flutter_structure/features/routes/routes.gr.dart';
 import 'package:flutter_structure/features/routes/app_routes_constants.dart';

 
 
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter();
  @override
  List<AutoRoute> get routes => <AutoRoute>[
        //Splash Screen
        AutoRoute(page: SplashRoute.page, initial: true,
        path: AppRoutesConstants.splash
        ),
      ];
}
