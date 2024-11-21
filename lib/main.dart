import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:get_it/get_it.dart';
 
import 'features/common/utility/theme.dart';
import 'features/di/dependency_init.dart';
import 'features/di/toggle_button_model.dart';
 import 'features/routes/router_observer.dart';
import 'features/routes/routes.dart';
import 'features/shared/cubit/locale_cubit/locale_cubit.dart';
import 'features/shared/cubit/theme_cubit/theme_cubit.dart';
import 'features/shared/widgets/custom_toggle_button/custom_toggle_button_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
 
  // await Firebase.initializeApp(
  //   name: "Swa",
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // FirebaseMessagingService().init();
  FlutterError.onError = (FlutterErrorDetails errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  getIt.registerSingleton<AppRouter>(AppRouter());

  // FlutterNativeSplash.preserve(
  //     widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  await configureDependencies();
  LocaleCubit _localCubit = getIt<LocaleCubit>();
  setupDI(); // Set up the DI
  await GetIt.I.isReady<ToggleModel>();
  //NotificationCubit _notificationCubit = getIt<NotificationCubit>();
  // _notificationCubit.initializeNotifications();
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
  ]);
  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const <Locale>[
        Locale('ar', 'KW'),
        Locale('en', 'US'),
      ],

      startLocale: _localCubit.getCurrentLocale(),
      saveLocale: false,
      // locale: const Locale('ar', 'KW'),
      fallbackLocale: const Locale('ar', 'KW'),
      child: MyApp(),
    ),
  );
}

void setupDI() {
// Register ToggleCubit
  getIt.registerSingleton<ToggleCubit>(ToggleCubit());

  // Register ToggleModel, inject ToggleCubit into it
  getIt.registerSingletonAsync<ToggleModel>(
    () async {
      ToggleModel model = ToggleModel(getIt<ToggleCubit>());
      await model.init(); // Initialize SharedPreferences
      return model;
    },
  );
}

class MyApp extends StatefulWidget {
  //LocaleCubit localeCubit = getIt<LocaleCubit>();
  MyApp({super.key});
  ThemeCubit themeCubit = getIt<ThemeCubit>();

  @override
  State<MyApp> createState() => _MyAppState();
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  _MyAppState();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final AppRouter _appRouter = getIt<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: false,
      designSize: const Size(430, 896),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: _appRouter.config(
            navigatorObservers: () => <NavigatorObserver>[
              CustomRouteObserver(),
            ],
          ),
          // darkTheme: AppTheme.darkTheme,
          theme: widget.themeCubit.getTheme() ?? AppTheme.lightTheme,
          themeMode: widget.themeCubit.getThemeMode() ?? ThemeMode.light,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: <LocalizationsDelegate>[
            FormBuilderLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            EasyLocalization.of(context)!.delegate,
          ],
          builder: EasyLoading.init(),
        );
      },
    );
  }

  void updateState() {
    setState(() {});
  }
}
