import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/helper/language_helper.dart';
import '../../../common/utility/palette.dart';
import '../../../common/utility/theme.dart';

class CustomSearchFieldWidget extends StatelessWidget {
  const CustomSearchFieldWidget({
    super.key,
    required this.searchHintText,
    required this.onPressed,
    this.searchFieldBackgroundColor,
    this.onChanged,
    required this.controller,
    this.iconColor,
    this.borderColor,
    this.width,
    this.iconPath,
    this.padding,
    this.onSubmitted,
  });
  final String searchHintText;
  final void Function()? onPressed;
  final Color? searchFieldBackgroundColor;
  final Color? iconColor;
  final Color? borderColor;
  final void Function(String)? onChanged;
  final TextEditingController controller;
  final double? width;
  final void Function(String)? onSubmitted;
  final String? iconPath;
  final EdgeInsets? padding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          EdgeInsets.only(
            right: LanguageHelper.isAr(context) ? 10.w : 0,
            left: LanguageHelper.isEN(context) ? 10.w : 0,
          ),
      child: TextField(
        textInputAction: TextInputAction.search,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          suffixIcon: iconPath != null
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: IconButton(
                    icon: SvgPicture.asset(iconPath!,
                        width: 15.w,
                        colorFilter: ColorFilter.mode(
                            AppTheme.inDarkMode(context,
                                dark: Palette.white, light: Palette.black)!,
                            BlendMode.srcIn)),
                    onPressed: onPressed,
                  ),
                )
              : null,
          contentPadding: EdgeInsets.only(top: 35.h, left: 20.w, right: 20.w),
          hintText: searchHintText,
          filled: true,
        ),
      ),
    );
  }
}
