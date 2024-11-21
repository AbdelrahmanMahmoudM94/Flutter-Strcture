import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_structure/features/shared/widgets/custom_elevated_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../di/dependency_init.dart';
import '../../routes/routes.dart';
import '../../shared/widgets/app_text.dart';
import '../utility/palette.dart';
import '../utility/theme.dart';
import 'language_helper.dart';

enum ImageExtension { svg, png }

class ViewsToolbox {
  static Future<bool> checkConnection() async {
    List<ConnectivityResult> result = <ConnectivityResult>[];

    result = await Connectivity().checkConnectivity();

    if (result.first == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

  static Future<File> convertBase64ToImage(
      String base64Str, String fileName) async {
    Uint8List bytes = base64Decode(base64Str);
    final Directory tempDir = await getTemporaryDirectory();
    File file = File('${tempDir.path}/$fileName.png');
    return await file.writeAsBytes(bytes);
  }

  static void dismissDialog({
    required BuildContext dialogContext,
  }) {
    Navigator.pop(dialogContext);
  }

  static void dismissLoading() {
    //CustomLoading.stop();

    EasyLoading.dismiss();
    // if (navigatorKey.currentContext!.canPop()) {
    //   Navigator.of(navigatorKey.currentContext!).pop();
    // }
  }

  static String getDiyarLogo(BuildContext context,
      {bool forcedLightTheme = false}) {
    if (forcedLightTheme) {
      return "assets/svg/diyar-logo-white.svg";
    } else {
      if (AppTheme.isDarkMode(context)) {
        if (LanguageHelper.isAr(context)) {
          return "assets/png/company_arabic_logo.png";
        } else {
          return "assets/svg/diyar-logo-white.svg";
        }
      } else {
        if (LanguageHelper.isAr(context)) {
          return "assets/png/company_arabic_logo.png";
        } else {
          return "assets/svg/diyar-logo.svg";
        }
      }
    }
  }

  //icon from base64 string
  static Widget iconFromBase64String(
    String base64String, {
    double? width,
    double? height,
    Color? color,
  }) {
    return SvgPicture.string(
      base64String,
      width: width,
      height: height,
      color: color,
    );
  }

  static Image imageFromBase64String(
    String base64String, {
    double? width,
    double? height,
    Color? color,
    BoxFit? boxFit,
  }) {
    return Image.memory(
      base64Decode(base64String),
      width: width,
      height: height,
      color: color,
      fit: boxFit,
    );
  }

  static Future<Uint8List?> loadAndConvertAssetImageToPNG(
      String assetPath) async {
    try {
      // Load image data from assets as a ByteData object
      ByteData byteData = await rootBundle.load(assetPath);

      // Convert ByteData to Uint8List
      Uint8List imageData = byteData.buffer.asUint8List();

      // Decode the Uint8List into a ui.Image
      ui.Codec codec = await ui.instantiateImageCodec(imageData);
      ui.FrameInfo frameInfo = await codec.getNextFrame();
      ui.Image image = frameInfo.image;

      // Convert the ui.Image to PNG ByteData
      ByteData? pngBytes =
          await image.toByteData(format: ui.ImageByteFormat.png);

      // Return Uint8List of the PNG data
      log(pngBytes!.buffer.asUint8List().toString());
      return pngBytes.buffer.asUint8List();
    } catch (e) {
      print('Error loading and converting image: $e');
    }
    return null;
  }

  static Future<void> openUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  static Future<void> shareImageAndDelete(
      File imageFile, String fileName) async {
    try {
      final XFile xFile = XFile(imageFile.path);

      await Share.shareXFiles(
        <XFile>[xFile],
        text: '$fileName Contact',
      );
    } finally {
      if (await imageFile.exists()) {
        await imageFile.delete();
      }
    }
  }

  static void showAwesomeSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
    bool isWarning = false,
    bool isSuccess = false,
    Duration duration = const Duration(milliseconds: 2500),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.transparent,
        duration: duration,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        content: AwesomeSnackbarContent(
          title: "",
          //title: "",          //color: Palette.secondaryGreen,
          message: message,
          color: isError
              ? Palette.darkRed
              : isWarning
                  ? Palette.orangeDark
                  : Palette.secondaryGreen,
          contentType: isError
              ? ContentType.failure
              : isWarning
                  ? ContentType.warning
                  : ContentType.success,
        ),
      ),
    );
  }

  static void showBottomSheet({
    double? height,
    Widget? widget,
    Widget? customWidget,
    BorderRadius? borderRadius,
    required BuildContext context,
  }) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (BuildContext context) {
        return customWidget ??
            Container(
              decoration: BoxDecoration(
                color: (AppTheme.isDarkMode(
                        getIt<AppRouter>().navigatorKey.currentContext!)
                    ? Palette.black
                    : Palette.white),
                borderRadius: borderRadius ??
                    BorderRadius.only(
                        topLeft: Radius.circular(40.r),
                        topRight: Radius.circular(40.r)),
              ),
              height: height ?? 300.h,
              width: 1.sw,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 20.h,
                  horizontal: 20.h,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _buildIndicator(),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              size: 30.w,
                            ),
                          ),
                        ],
                      ),
                      widget ?? Container(),
                    ],
                  ),
                ),
              ),
            );
      },
    );
  }

  static void showCustomBottomSheet({
    double? height,
    Widget? customWidget,
    bool? removePadding = false,
    bool? isDismissible,
    BorderRadius? borderRadius,
    required BuildContext context,
  }) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      isDismissible: isDismissible ?? true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 50.h,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: (AppTheme.isDarkMode(
                      getIt<AppRouter>().navigatorKey.currentContext!)
                  ? Palette.semiLightBlack
                  : Palette.white),
              borderRadius: borderRadius ??
                  BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
            ),
            height: height ?? 300.h,
            width: 1.sw,
            child: (removePadding ?? false)
                ? customWidget
                : Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 20.h,
                      horizontal: 20.h,
                    ),
                    child: customWidget,
                  ),
          ),
        );
      },
    );
  }

  // static void showWarningDialogContent(
  //   String warningtext,
  //   BuildContext? warningContext,
  //   Function() onCancelTap, {
  //   bool closeIconVisible = true,
  //   bool continueButtonVisible = true,
  //   String? cancelText,
  // }) {
  //   ViewsToolbox.showCustomDialog(
  //     dialogContext: Constant.navigatorKey.currentState!.context,
  //     getDialogContext: (BuildContext dialogContext) {
  //       warningContext = dialogContext;
  //     },
  //     backgroundImagePath: 'assets/images/popup-new-pattern.png',
  //     imageExtension: ImageExtension.png,
  //     showCloseIcon: closeIconVisible,
  //     widgets: <Widget>[
  //       Padding(
  //         padding: EdgeInsets.symmetric(vertical: 10.h),
  //         child: SvgPicture.asset(
  //           "assets/svg/cancel-joining-alert-icon.svg",
  //           width: 60.w,
  //         ),
  //       ),
  //       Text(
  //         warningtext,
  //         style: AppTheme.textTheme.bodyLarge,
  //         textAlign: TextAlign.center,
  //       ),
  //       25.heightBox,
  //       continueButtonVisible
  //           ? CustomElevatedButton(
  //               text: cancelText ?? "cancel-text".tr(),
  //               borderColor: Palette.black,
  //               textColor: Palette.lightBlack,
  //               backgroundColor: Palette.white,
  //               onPressed: () {
  //                 Navigator.pop(warningContext!);
  //                 onCancelTap();
  //               },
  //             )
  //           : Container(),
  //       20.heightBox,
  //     ],
  //   );
  // }

  // static void showSuccessDialogContent({
  //   String? text,
  //   BuildContext? successContext,
  //   Function()? onContinueTap,
  //   bool closeIconVisible = true,
  //   String? cancelText,
  // }) {
  //   ViewsToolbox.showCustomDialog(
  //     dialogContext: Constant.navigatorKey.currentState!.context,
  //     getDialogContext: (BuildContext dialogContext) {
  //       successContext = dialogContext;
  //     },
  //     backgroundImagePath: 'assets/images/popup-new-pattern.png',
  //     imageExtension: ImageExtension.png,
  //     showCloseIcon: closeIconVisible,
  //     widgets: <Widget>[
  //       Padding(
  //         padding: EdgeInsets.symmetric(vertical: 10.h),
  //         child: SvgPicture.asset(
  //           "assets/svg/success-dialog-icon.svg",
  //           width: 40.w,
  //         ),
  //       ),
  //       Text(
  //         text ?? "success-request".tr(),
  //         style: AppTheme.textTheme.bodyLarge,
  //         textAlign: TextAlign.center,
  //       ),
  //       20.heightBox,
  //       CustomElevatedButton(
  //         text: "continue-text".tr(),
  //         textColor: Palette.white,
  //         onPressed: () {
  //           Navigator.pop(successContext!);
  //           onContinueTap?.call();
  //         },
  //       ),
  //     ],
  //   );
  // }

  // static void showTimeOutDialogContent(
  //   String warningtext,
  //   BuildContext? warningContext,
  //   Function() onCancelTap, {
  //   bool closeIconVisible = false,
  //   String? cancelText,
  // }) {
  //   ViewsToolbox.showCustomDialog(
  //     dialogContext: Constant.navigatorKey.currentState!.context,
  //     getDialogContext: (BuildContext dialogContext) {
  //       warningContext = dialogContext;
  //     },
  //     backgroundImagePath: 'assets/images/popup-new-pattern.png',
  //     imageExtension: ImageExtension.png,
  //     showCloseIcon: closeIconVisible,
  //     widgets: <Widget>[
  //       Padding(
  //         padding: EdgeInsets.symmetric(vertical: 10.h),
  //         child: SvgPicture.asset(
  //           "assets/svg/cancel-joining-alert-icon.svg",
  //           width: 60.w,
  //         ),
  //       ),
  //       Text(
  //         warningtext,
  //         style: AppTheme.textTheme.bodyLarge,
  //         textAlign: TextAlign.center,
  //       ),
  //       25.heightBox,
  //       CustomElevatedButton(
  //         text: cancelText ?? "home-text".tr(),
  //         borderColor: Palette.black,
  //         textColor: Palette.lightBlack,
  //         backgroundColor: Palette.white,
  //         onPressed: () {
  //           Navigator.pop(warningContext!);
  //           Constant.navigatorKey.currentContext!
  //               .read<BottomNavigationCubit>()
  //               .changeIndex(0);
  //           Constant.navigatorKey.currentContext!.push(AppRoutes.bottomBar);
  //         },
  //       ),
  //       20.heightBox,
  //     ],
  //   );
  // }

  static void showCustomDialog({
    required BuildContext dialogContext,
    required List<Widget> widgets,
    required Function(BuildContext) getDialogContext,
    Function()? refresh,
    double? radius,
    String? logoImagePath,
    String? header,
    String? backgroundImagePath,
    ImageExtension? imageExtension,
    ImageExtension? logoExtension,
    Positioned? backgroundPositioned,
    bool showCloseIcon = false,
    Offset? backgroundImageOffset,
    Color? backgroundColorAlertDialog,
    bool? allowDismiss,
  }) {
    if (refresh != null) {
      refresh();
    }
    final AlertDialog alert = AlertDialog(
      backgroundColor: backgroundColorAlertDialog,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? 15.r),
      ),
      content: Directionality(
        textDirection: LanguageHelper.isAr(dialogContext)
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: StatefulBuilder(
          builder: (BuildContext builderContext, StateSetter myState) {
            return Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                backgroundImagePath != null
                    ? Positioned(
                        top: backgroundPositioned?.top ?? -19.h,
                        left: 0,
                        right: 0,
                        child: imageExtension == ImageExtension.svg
                            ? SvgPicture.asset(
                                backgroundImagePath,
                              )
                            : Image.asset(
                                backgroundImagePath,
                              ),
                      )
                    : const SizedBox(
                        width: 0,
                        height: 0,
                      ),
                showCloseIcon
                    ? Positioned(
                        left: LanguageHelper.isAr(dialogContext) ? -20.w : null,
                        right:
                            LanguageHelper.isEN(dialogContext) ? -20.w : null,
                        top: -15.h,
                        child: IconButton(
                          onPressed: () => ViewsToolbox.dismissDialog(
                            dialogContext: builderContext,
                          ),
                          icon: Icon(
                            Icons.close,
                            textDirection: LanguageHelper.isAr(dialogContext)
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            size: 27.w,
                            color: AppTheme.isDarkMode(dialogContext)
                                ? Palette.white
                                : Palette.black,
                          ),
                        ),
                      )
                    : const SizedBox(
                        width: 0,
                        height: 0,
                      ),
                header != null
                    ? Positioned(
                        top: 12.h,
                        left: 0,
                        right: 0,
                        child: AppText(
                          textAlign: TextAlign.center,
                          text: header,
                          fontSize: 28,
                          fontWeight: AppFontWeight.bold,
                        ),
                      )
                    : const SizedBox(
                        width: 0,
                        height: 0,
                      ),
                Padding(
                  padding: EdgeInsets.only(
                    top: header != null ? 40.h : 0.h,
                  ),
                  child: SizedBox(
                    width: 600.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: widgets,
                    ),
                  ),
                ),
                logoImagePath != null
                    ? Transform.translate(
                        offset: LanguageHelper.isAr(dialogContext)
                            ? Offset(-98.w, -96.h)
                            : Offset(102.w, -97.h),
                        child: Container(
                          width: 90.w,
                          height: 90.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Palette.white,
                          ),
                          child: Center(
                              child: logoExtension == ImageExtension.svg
                                  ? SvgPicture.asset(logoImagePath)
                                  : Image.asset(logoImagePath)),
                        ),
                      )
                    : const SizedBox(
                        width: 0,
                        height: 0,
                      ),
              ],
            );
          },
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: dialogContext,
      barrierDismissible: allowDismiss ?? false,
      builder: (BuildContext context) {
        getDialogContext(context);
        return alert;
      },
    );
  }

  static void showErrorAwesomeSnackBar(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        dismissDirection: DismissDirection.startToEnd,
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.transparent,
        duration: const Duration(milliseconds: 2500),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        content: AwesomeSnackbarContent(
          title: "",
          //title: "",          //color: Palette.secondaryGreen,
          message: message,
          color: Palette.darkRed,

          contentType: ContentType.failure,
        ),
      ),
    );
  }

  static void showLoading({bool allowClicking = false}) {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 60.w
      ..textColor =
          AppTheme.isDarkMode(getIt<AppRouter>().navigatorKey.currentContext!)
              ? Palette.semiLightBlack
              : Palette.white
      ..radius = 20
      ..backgroundColor =
          AppTheme.isDarkMode(getIt<AppRouter>().navigatorKey.currentContext!)
              ? Palette.white
              : Palette.darkGray
      ..maskColor =
          AppTheme.isDarkMode(getIt<AppRouter>().navigatorKey.currentContext!)
              ? Palette.transparntColor
              : Palette.darkGray
      ..indicatorColor =
          AppTheme.isDarkMode(getIt<AppRouter>().navigatorKey.currentContext!)
              ? Palette.semiLightBlack
              : Palette.white
      ..userInteractions = false
      ..dismissOnTap = allowClicking
      ..boxShadow = <BoxShadow>[]
      ..indicatorType = EasyLoadingIndicatorType.circle;
    EasyLoading.show(
      status: getIt<AppRouter>()
          .navigatorKey
          .currentContext!
          .tr("loadingTextDialog"),
    );
    // CustomLoading(gif).start(
    //   Constant.navigatorKey.currentContext!,
    //   // overlayColor: Palette.greyBackgroundTheme.withOpacity(0.2),
    //   overlayColor: Colors.transparent,
    // );
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   showDialog(
    //     context: navigatorKey.currentContext!,
    //     barrierDismissible: false,
    //     builder: (BuildContext context) {
    //       return Container(
    //         child: Center(
    //           child: Image.asset(
    //             "assets/images/hawi.gif",
    //             width: 190.w,
    //           ),
    //         ),
    //       );
    //     },
    //   );
    // });
  }

  static void showSuccessAwesomeSnackBar(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        dismissDirection: DismissDirection.startToEnd,
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.transparent,
        duration: const Duration(milliseconds: 2500),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        content: AwesomeSnackbarContent(
          title: "",
          //title: "",          //color: Palette.secondaryGreen,
          message: message,
          color: Palette.secondaryGreen,
          contentType: ContentType.success,
        ),
      ),
    );
  }

  static void showWarningAwesomeSnackBar(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        dismissDirection: DismissDirection.startToEnd,
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.transparent,
        duration: const Duration(milliseconds: 2500),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        content: AwesomeSnackbarContent(
          title: "",
          //title: "",          //color: Palette.secondaryGreen,
          message: message,
          color: Palette.orangeDark,

          contentType: ContentType.warning,
        ),
      ),
    );
  }

  static Container _buildIndicator() {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      width: 70.w,
      height: 5.h,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.3),
        borderRadius: BorderRadius.circular(30.w),
      ),
    );
  }

  static showConfirmationDialog(
      {required BuildContext context,
      required String dialogMessage,
      required void Function() onConfirmCallback,
      String? dialogSubTitleMessage}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.all(24.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.info,
                size: 60,
                color: Colors.blue,
              ),
              const SizedBox(height: 10),
              AppText(
                text: context.tr(dialogMessage),
                textAlign: TextAlign.center,
              ),
              10.verticalSpace,
              if (dialogSubTitleMessage != null)
                AppText(
                  text: context.tr(dialogSubTitleMessage),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add your confirmation logic here
              },
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.isDarkMode(context)
                    ? Palette.black
                    : Palette.white,
                // side: const BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: AppText(
                text: context.tr('back'),
              ),
            ),
            CustomElevatedButton(
                width: 120.w,
                onPressed: onConfirmCallback,
                text: context.tr('confirm')),
          ],
        );
      },
    );
  }
}
