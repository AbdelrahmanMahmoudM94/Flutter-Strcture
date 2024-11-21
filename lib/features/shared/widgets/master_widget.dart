import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_structure/features/common/utility/theme.dart';
import 'package:flutter_structure/features/routes/route_sevices.dart';
import 'package:flutter_structure/features/shared/widgets/app_text.dart';
 

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
    this.hasFoucs = false,
    this.hasInternet,
    this.isSupportOffline = false,
    required this.screenTitle,
    this.appBar,
    this.showActionsIcon = true,
    this.showLeading = true,
    this.floatingActionButton,
  });

  final Widget? floatingActionButton;
  final String? path;
  final PatternExtension? patternExtension;
  final Widget widget;
  final double? patternHeight;
  final bool? hasScroll;
  final bool? hasFoucs;
  final bool? isSupportOffline;
  final Function(bool)? hasInternet;
  final String screenTitle;
  final AppBar? appBar;
  final bool showActionsIcon;
  final bool showLeading;

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) async {
      hasInternet.value = await ViewsToolbox.checkConnection();
    });

    // Log the initial keyboard visibility state.
    print(
        'Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // Subscribe to keyboard visibility changes.
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      isKeyboardVisible.value = visible;
      if (mounted) {
        setState(() {});
      }

      print('Keyboard visibility update. Is visible: $visible');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: widget.floatingActionButton,
        appBar: widget.appBar ??
            AppBar(
              centerTitle: true,
              title: AppText(
                text: widget.screenTitle,
                fontSize: 20,
                textColor: AppTheme.inDarkMode(context,
                    light: Colors.black, dark: Colors.white),
              ),
              backgroundColor: Colors.transparent,
              leading: widget.showLeading
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: AppTheme.inDarkMode(context,
                            light: Colors.black, dark: Colors.white),
                      ),
                      onPressed: () {
                        CustomMainRouter.pop();
                      },
                    )
                  : null,
              actions: widget.showActionsIcon
                  ? <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          minimumSize: Size.zero,
                        ),
                        child: Icon(
                          Icons.notifications,
                          color: AppTheme.isDarkMode(context)
                              ? Colors.white
                              : Colors.black,
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
                        child: Icon(
                          Icons.chat,
                          color: AppTheme.isDarkMode(context)
                              ? Colors.white
                              : Colors.black,
                        ),
                        onPressed: () {},
                      ),
                    ]
                  : null,
            ),
        //  backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            width: 1.sw,
            child: StreamBuilder<List<ConnectivityResult>>(
                stream: Connectivity().onConnectivityChanged,
                builder: (BuildContext context,
                    AsyncSnapshot<List<ConnectivityResult>> snapshot) {
                  if (snapshot.data != null) {
                    if (snapshot.data?.first == ConnectivityResult.none) {
                      ViewsToolbox.dismissLoading();
                      GeneralConstants.hasConnection = false;

                      widget.hasInternet?.call(false);
                      if (GeneralConstants.hasConnection == true) {
                        GeneralConstants.hasConnection = false;
                      }
                    } else {
                      hasInternet.value = true;

                      if (hasInternet.value &&
                          GeneralConstants.hasConnection == false) {
                        widget.hasInternet?.call(true);
                      }
                      if (GeneralConstants.hasConnection == false) {
                        GeneralConstants.hasConnection = true;
                      }
                    }
                  }
                  return ValueListenableBuilder<bool>(
                    valueListenable: hasInternet,
                    builder: (BuildContext context, bool value,
                            Widget? child) =>
                        widget.hasScroll!
                            ? SingleChildScrollView(
                                reverse: isKeyboardVisible.value ? true : false,
                                child: widget.isSupportOffline!
                                    ? widget.widget
                                    : snapshot.data?.first ==
                                                ConnectivityResult.none ||
                                            !hasInternet.value
                                        ? const NoInternetConnection()
                                        : widget.widget,
                              )
                            : widget.isSupportOffline!
                                ? widget.widget
                                : snapshot.data?.first ==
                                            ConnectivityResult.none ||
                                        !hasInternet.value
                                    ? const NoInternetConnection()
                                    : widget.widget,
                  );
                }),
          ),
        ));
  }
}
