import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
 import 'package:flutter_structure/features/common/helper/language_helper.dart';
import 'package:flutter_structure/features/common/helper/layout_helper.dart';
import 'package:flutter_structure/features/common/utility/palette.dart';
import 'package:flutter_structure/features/common/utility/theme.dart';
import 'package:flutter_structure/features/shared/widgets/app_text.dart';
import 'package:flutter_structure/features/shared/widgets/no_data_widget.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
 
import '../../common/constants/general_constants.dart';
import '../../common/helper/view_toolbox.dart';
import 'no_internet_connection.dart';

class MasterWidget extends StatefulWidget {
  const MasterWidget({
    super.key,
    this.path,
    this.patternExtension,
    required this.widget,
    this.patternHeight,
    this.hasScroll = true,
    this.hasFocus = false,
    this.hasInternet,
    this.isSupportOffline = false,
    required this.screenTitle,
    this.appBar,
    this.showActionsIcon = true,
    this.actionsWidgets,
    this.showLeading = true,
    this.floatingActionButton,
    this.showDefaultAppBar = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.showBackButtonInActions = false,
    this.applyTabletToolbarHeight = true,
    this.topEnableSafeArea = true,
    this.bottomEnableSafeArea = true,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.defaultAutomaticallyImplyLeading = true,
    this.defaultAppBarCenterTitle = true,
    this.resizeToAvoidBottomInset = false,
    this.masterWidgetDefaultStackLayersData,
    this.customStackLayers = const [],
    this.backgroundColor,
    this.onBackButton,
    this.screenTitleColor,
    this.screenTitleStyle,
    this.toolbarHeight,
    this.onKeyboardOpen,
    this.scrollController,
    this.hideContent = false,
    this.showDividerUnderAppBar = false,
  });

  final void Function()? onBackButton;
  final Widget? floatingActionButton;
  final String? path;
  final PatternExtension? patternExtension;
  final Widget widget;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final double? patternHeight;
  final bool? hasScroll;
  final bool? hasFocus;
  final bool? isSupportOffline;
  final Function(bool)? hasInternet;
  final String screenTitle;
  final AppBar? appBar;
  final bool showActionsIcon;
  final bool showBackButtonInActions;
  final List<Widget>? actionsWidgets;
  final bool showLeading;
  final bool showDefaultAppBar;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final bool topEnableSafeArea;
  final bool bottomEnableSafeArea;
  final bool defaultAutomaticallyImplyLeading;
  final bool defaultAppBarCenterTitle;
  final bool resizeToAvoidBottomInset;
  final Color? backgroundColor;
  final Color? screenTitleColor;
  final bool? applyTabletToolbarHeight;
  final AppTextStyle? screenTitleStyle;
  final double? toolbarHeight;
  final MasterWidgetStackLayersData? masterWidgetDefaultStackLayersData;
  final List<Widget> customStackLayers;
  final Function(bool)? onKeyboardOpen;
  final ScrollController? scrollController;
  final bool hideContent;
  final bool showDividerUnderAppBar;

  @override
  State<MasterWidget> createState() => _MasterWidgetState();
}

enum PatternExtension { png, svg }

class _MasterWidgetState extends State<MasterWidget> {
  List<ConnectivityResult> connectionResult = <ConnectivityResult>[];
  ValueNotifier<bool> hasInternet = ValueNotifier<bool>(true);
  late StreamSubscription<bool> keyboardSubscription;
  ValueNotifier<bool> isKeyboardVisible = ValueNotifier<bool>(false);
  final KeyboardVisibilityController keyboardVisibilityController =
      KeyboardVisibilityController();
  Connectivity connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) async {
      hasInternet.value = await ViewsToolbox.checkConnection();
    });

    connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    // Log the initial keyboard visibility state.

    // Subscribe to keyboard visibility changes.
    keyboardSubscription = keyboardVisibilityController.onChange.listen((
      bool visible,
    ) {
      isKeyboardVisible.value = visible;
      if (mounted) {
        widget.onKeyboardOpen?.call(visible);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() {});
        });
      }
    });
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    if (result.contains(ConnectivityResult.none)) {
      ViewsToolbox.dismissLoading();
      GeneralConstants.hasConnection = false;

      hasInternet.value = false;
      if (GeneralConstants.hasConnection == true) {
        GeneralConstants.hasConnection = false;
      }
    } else {
      // context.read<LoggedInChatSocketCubit>().forceConnectSocket();
      //context.read<LoggedInMessagesCubit>().syncOfflineMessages();

      hasInternet.value = true;

      if (hasInternet.value && GeneralConstants.hasConnection == false) {
        widget.hasInternet?.call(true);
      }
      GeneralConstants.hasConnection = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> layersToStack = (widget.customStackLayers.isNotEmpty)
        ? widget.customStackLayers
        : (widget.masterWidgetDefaultStackLayersData != null)
            ? _buildDefaultStackLayers(
                context,
                widget.masterWidgetDefaultStackLayersData!,
              )
            : [];
    return Scaffold(
      bottomNavigationBar: widget.bottomNavigationBar,
      bottomSheet: widget.bottomSheet,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      body: Stack(
        children: [
          ...layersToStack,
          GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
            child: ValueListenableBuilder<bool>(
              valueListenable: hasInternet,
              builder: (BuildContext context, bool value, Widget? child) {
                bool showAppBar = widget.isSupportOffline!
                    ? true
                    : !hasInternet.value
                        ? false
                        : true;
                return Scaffold(
                  extendBody: widget.extendBody,
                  extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
                  floatingActionButton: widget.floatingActionButton,
                  backgroundColor: widget.backgroundColor ??
                      (AppTheme.isDarkMode(context)
                          ? Palette.blue_1F2A37
                          : Palette.grey_F2F2F2),

                  appBar: showAppBar
                      ? widget.appBar ??
                          (widget.showDefaultAppBar
                              ? _buildMasterWidgetDefaultAppBar(
                                  context,
                                  widget.onBackButton,
                                )
                              : null)
                      : null,
                  //  backgroundColor: Colors.transparent,
                  resizeToAvoidBottomInset: false,
                  body: SafeArea(
                    top: showAppBar ? widget.topEnableSafeArea : true,
                    bottom: showAppBar ? widget.bottomEnableSafeArea : true,
                    child: SizedBox(
                      width: 1.sw,
                      child: widget.hideContent
                          ? NoDataWidget()
                          : ValueListenableBuilder<bool>(
                              valueListenable: hasInternet,
                              builder: (
                                BuildContext context,
                                bool value,
                                Widget? child,
                              ) =>
                                  widget.hasScroll!
                                      ? SingleChildScrollView(
                                          controller: widget.scrollController,
                                          reverse: isKeyboardVisible.value
                                              ? true
                                              : false,
                                          child: widget.isSupportOffline!
                                              ? widget.widget
                                              : !GeneralConstants.hasConnection
                                                  ? const NoInternetConnection()
                                                  : widget.widget,
                                        )
                                      : widget.isSupportOffline!
                                          ? widget.widget
                                          : !GeneralConstants.hasConnection
                                              ? const NoInternetConnection()
                                              : widget.widget,
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the default app bar for the master widget.
  ///
  /// This app bar will be rendered when the [MasterWidget] is not provided with
  /// a custom app bar.
  ///
  /// The app bar will have the following properties:
  ///
  /// - A transparent background color.
  /// - A title text that is the same as the [screenTitle] property of the
  ///   [MasterWidget].
  /// - A leading icon that is the back button.
  /// - An action icon that is the calendar icon.
  /// - An action icon that is the notification icon.
  /// - An action icon that is the chat icon.
  ///
  /// The app bar will also have the following behaviors:
  ///
  /// - When the back button is pressed, the [CustomMainRouter.pop] will be called.
  /// - When the calendar icon is pressed, the [LoggedInUserCalendar] will be
  ///   pushed to the router.
  /// - When the notification icon is pressed, the [VisitorNotificationsRoute] will
  ///   be pushed to the router.
  /// - When the chat icon is pressed, nothing will happen.
  AppBar _buildMasterWidgetDefaultAppBar(BuildContext context, onBackButton) {
    return AppBar(
      titleSpacing: widget.defaultAutomaticallyImplyLeading ? 0.w : 20.w,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Palette.transparentColor,
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: Visibility(
          visible: widget.showDividerUnderAppBar,
          child: Divider(color: Palette.blue_384250, thickness: 1),
        ),
      ),
      centerTitle: widget.defaultAppBarCenterTitle,
      automaticallyImplyLeading: widget.defaultAutomaticallyImplyLeading,
      iconTheme: IconThemeData(
        color: AppTheme.inDarkMode(
          context,
          light: Theme.of(context).primaryColor,
          dark: Theme.of(context).primaryColor,
        ),
        size: 22.sp,
      ),
      actionsIconTheme: IconThemeData(
        color: AppTheme.inDarkMode(
          context,
          light: Theme.of(context).primaryColor,
          dark: Theme.of(context).primaryColor,
        ),
        size: 22.sp,
      ),
      toolbarHeight: widget.toolbarHeight ??
          (LayoutHelper.isTablet() && widget.applyTabletToolbarHeight!
              ? 120.h
              : LayoutHelper.isSmallMobile()
                  ? 90.h
                  : 70.h),
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: AppText(
          text: widget.screenTitle,
          style: widget.screenTitleStyle ?? AppTextStyle.semiBold_19,
          fontFamily: "IBMPlexArabic",
          maxLines: 2,
          textColor: widget.screenTitleColor ??
              AppTheme.inDarkMode(
                context,
                light: Theme.of(context).primaryColor,
                dark: Theme.of(context).primaryColor,
              ),
        ),
      ),
      backgroundColor: Colors.transparent,
      leading: widget.showLeading
          ? Transform.flip(
              flipX: LanguageHelper.isEN(context),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Center(
                    child: SvgPicture.asset(
                      width: LayoutHelper.isTablet() ? 15.w : 17.w,
                      "assets/svg/new-back-icon.svg",
                    ),
                  ),
                ),
              ),
            )
          : null,
      actions: widget.showActionsIcon
          ? widget.showBackButtonInActions
              ? [
                  Transform.flip(
                    flipX: LanguageHelper.isEN(context),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Center(
                          child: SvgPicture.asset(
                            width: LayoutHelper.isTablet() ? 15.w : 17.w,
                            "assets/svg/new-back-icon.svg",
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
              : widget.actionsWidgets ??
                  <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        minimumSize: Size.zero,
                      ),
                      child: Icon(
                        Icons.calendar_month_outlined,
                        color: AppTheme.isDarkMode(context)
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        //     CustomMainRouter.push(LoggedInUserCalendar());
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        minimumSize: Size.zero,
                      ),
                      child: Image.asset(
                        "assets/icons/notifications.png",
                        width: 20.sp,
                        color: AppTheme.isDarkMode(context)
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        //TODO: check current user type visitor or logged in user
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        minimumSize: Size.zero,
                      ),
                      child: Image.asset(
                        "assets/icons/chat.png",
                        width: 20.sp,
                        color: AppTheme.isDarkMode(context)
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).primaryColor,
                      ),
                      onPressed: () {},
                    ),
                  ]
          : null,
    );
  }

  List<Widget> _buildDefaultStackLayers(
    BuildContext context,
    MasterWidgetStackLayersData data,
  ) {
    return [
      if (data.showBottomSeparator)
        Positioned.fromRect(
          rect: Rect.fromLTRB(0, 0, 1.sw, data.topRatio.sh),
          child: Container(
            decoration: BoxDecoration(
              color: data.topColor,
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.inDarkMode(
                        context,
                        light: Palette.blue_384250,
                        dark: Palette.blue_384250,
                      ) ??
                      Palette.blue_384250,
                ),
              ),
            ),
          ),
        ),
      Positioned.fromRect(
        rect: Rect.fromLTRB(0, data.topRatio.sh, 1.sw, data.bottomRatio.sh),
        child: Container(color: data.bottomColor),
      ),
      data.isPlain
          ? Container()
          : Positioned.fromRect(
              rect: Rect.fromLTRB(0, 0, 1.sw, data.topRatio.sh),
              child: SvgPicture.asset(
                data.assetPath ?? "assets/svg/profile_background.svg",
                allowDrawingOutsideViewBox: true,
                clipBehavior: Clip.hardEdge,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  data.svgColor,
                  AppTheme.isDarkMode(context)
                      ? BlendMode.srcIn
                      : BlendMode.plus,
                ),
              ),
            ),
    ];
  }
}

class MasterWidgetStackLayersData {
  final String? assetPath;
  final double topRatio;
  final double bottomRatio;
  final Color topColor;
  final Color bottomColor;
  final Color svgColor;
  final bool isPlain;
  final bool showBottomSeparator;

  MasterWidgetStackLayersData({
    this.assetPath,
    required this.topRatio,
    required this.bottomRatio,
    required this.topColor,
    required this.bottomColor,
    this.svgColor = Palette.transparentColor,
    this.isPlain = false,
    this.showBottomSeparator = false,
  });
}
