import 'package:cupertino_ui/cupertino_ui.dart' as cui;
import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
 import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_structure/features/common/extensions/size_extensions.dart';
import 'package:flutter_structure/features/common/utility/theme.dart';
import 'package:flutter_structure/features/shared/widgets/app_text.dart';
import 'package:flutter_structure/features/shared/widgets/custom_elevated_button_widget.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:restart_app/restart_app.dart';

import '../utility/palette.dart';

class FatalErrorHandler {
  FatalErrorHandler._();

  static final ValueNotifier<Object?> _failure = ValueNotifier<Object?>(null);

  static void initialize() {
    FlutterError.onError = _handleFlutterError;
    PlatformDispatcher.instance.onError = _handlePlatformError;
    ErrorWidget.builder = (_) => const SizedBox.shrink();
  }

  static void _handleFlutterError(FlutterErrorDetails details) {
    final StackTrace stack = details.stack ?? StackTrace.current;
    unawaited(_recordFlutterError(details));
  }

  static bool _handlePlatformError(Object error, StackTrace stack) {
    _show(error);
    unawaited(_recordPlatformError(error, stack));
    return true;
  }

  static void _show(Object error) {
    scheduleMicrotask(() => _failure.value ??= error);
  }

  static Future<void> _recordFlutterError(FlutterErrorDetails details) async {
    try {
      await FirebaseCrashlytics.instance.log(details.exceptionAsString());
      await FirebaseCrashlytics.instance.recordFlutterError(details);
    } catch (error, stack) {}
  }

  static Future<void> _recordPlatformError(
    Object error,
    StackTrace stack,
  ) async {
    try {
      await FirebaseCrashlytics.instance.log(error.toString());
      await FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    } catch (reportingError, reportingStack) {}
  }

  /// Restarts the whole app by recreating the Flutter engine.
  ///
  /// This wipes all Dart state (singletons, DI, navigation, in-flight
  /// requests, timers and streams) and re-runs `main()` from scratch,
  /// mirroring a hot restart.
  static Future<RestartResult> restartApp() => Restart.restartApp();
}

class FatalErrorBoundary extends StatefulWidget {
  const FatalErrorBoundary({required this.child, super.key});

  final Widget child;

  @override
  State<FatalErrorBoundary> createState() => _FatalErrorBoundaryState();
}

class _FatalErrorBoundaryState extends State<FatalErrorBoundary> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Object?>(
      valueListenable: FatalErrorHandler._failure,
      builder: (BuildContext context, Object? failure, Widget? child) {
        if (failure != null) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            // easy_localization only supplies the SDK flutter_localizations
            // delegates, which do not satisfy material_ui / cupertino_ui; add
            // theirs too (same set as the main app) or Flutter warns that the
            // locale (ar_KW) is unsupported whenever this screen is shown.
            localizationsDelegates: <LocalizationsDelegate<dynamic>>[
              ...GlobalMaterialLocalizations.delegates,
              ...cui.GlobalCupertinoLocalizations.delegates,
              ...context.localizationDelegates,
            ],
            theme: ThemeData(
              useMaterial3: false,
              brightness: Brightness.dark,
              fontFamily: 'IBMPlexArabic',
              primaryColor: Palette.blueTheme,
              scaffoldBackgroundColor: Palette.blueTheme,
              colorScheme: const ColorScheme.dark(primary: Palette.blueTheme),
            ),
            home: const FatalErrorScreen(),
          );
        }

        return child!;
      },
      child: widget.child,
    );
  }
}

class FatalErrorScreen extends StatefulWidget {
  const FatalErrorScreen({super.key});

  @override
  State<FatalErrorScreen> createState() => _FatalErrorScreenState();
}

class _FatalErrorScreenState extends State<FatalErrorScreen> {
  bool _restarting = false;

  Future<void> _onRestart() async {
    if (_restarting) {
      return;
    }
    setState(() => _restarting = true);
    try {
      final RestartResult result = await FatalErrorHandler.restartApp();
      if (!result.success) {
        if (mounted) {
          setState(() => _restarting = false);
        }
      }
    } catch (error, stack) {
      if (mounted) {
        setState(() => _restarting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Palette.blueTheme,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Directionality(
        textDirection: context.locale.languageCode == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 560),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Center(
                              child: SvgPicture.asset(
                                AppTheme.isDarkMode(context)
                                    ? "assets/svg/swa_main_logo.svg"
                                    : "assets/svg/swa_main_black_logo.svg",
                                width: 160.w,
                              ),
                            ),
                            30.heightBox,
                            Column(
                              children: <Widget>[
                                Container(
                                  width: 88,
                                  height: 88,
                                  decoration: BoxDecoration(
                                    color: Palette.redBackgroundTheme.withValues(
                                      alpha: .12,
                                    ),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Palette.redBackgroundTheme.withValues(
                                        alpha: .4,
                                      ),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.error_outline_rounded,
                                    color: Palette.redBackgroundTheme,
                                    size: 52,
                                  ),
                                ),
                                30.heightBox,
                                AppText(
                                  text: context.tr('fatalErrorTitle'),
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.medium_24,
                                ),
                                5.heightBox,
                                AppText(
                                  text: context.tr('fatalErrorDescription'),
                                  textAlign: TextAlign.center,
                                  textColor: Palette.greyDivider,
                                  style: AppTextStyle.regular_15,
                                ),
                                50.heightBox,

                                CustomElevatedButton(
                                  onPressed: _restarting ? () {} : _onRestart,
                                  text: context.tr('restartApp'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
