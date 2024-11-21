// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_structure/features/common/extensions/size_extensions.dart';
import 'package:flutter_structure/features/common/utility/palette.dart';
import 'package:flutter_structure/features/common/utility/theme.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ToggleButtonWidget extends StatefulWidget {
  ToggleButtonWidget(
      {super.key,
      required this.toggleModels,
      this.minWidth,
      this.removePadding = false});
  final List<ToggleModel>? toggleModels;
  final double? minWidth;
  bool removePadding;
  @override
  State<ToggleButtonWidget> createState() => _ToggleButtonWidgetState();
}

class _ToggleButtonWidgetState extends State<ToggleButtonWidget> {
  bool _checkboxEn = true;

  bool _checkboxAr = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.removePadding
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        children: <Widget>[
          10.heightBox,
          ToggleSwitch(
            minWidth: widget.minWidth ?? 200.w,
            minHeight: 35.h,
            fontSize: 16.sp,
            borderColor: <Color>[Palette.greyDivider],
            borderWidth: 1,
            initialLabelIndex: 0,
            activeBgColor: <Color>[Palette.lightBlue],
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.white,
            inactiveFgColor: AppTheme.inDarkMode(context,
                dark: Palette.black, light: Palette.black),
            totalSwitches: widget.toggleModels!.length,
            textDirectionRTL: context.locale == Locale('ar', 'KW'),
            labels:
                widget.toggleModels!.map((ToggleModel e) => e.label).toList(),
            onToggle: (int? index) async {
              widget.toggleModels![index!].onToggle;
            },
          ),
        ],
      ),
    );
  }
}

class ToggleModel {
  final String label;
  final Function(int?)? onToggle;
  ToggleModel({
    required this.label,
    this.onToggle,
  });
}
