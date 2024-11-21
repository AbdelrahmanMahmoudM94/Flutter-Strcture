import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/utility/palette.dart';
import '../../../common/utility/theme.dart';
import '../app_text.dart';

class PasswordFieldWidget extends StatelessWidget {
  const PasswordFieldWidget(
      {super.key,
      required this.keyName,
      this.validator,
      this.hintText,
      this.hintStyle,
      this.suffixIcon,
      this.contentPadding,
      this.labelAboveField,
      this.controller,
      this.obscureText = true});
  final String keyName;
  final String? labelAboveField;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextStyle? hintStyle;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final TextEditingController? controller;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AppText(
          text: labelAboveField,
          textColor: AppTheme.inDarkMode(context,
              dark: Palette.white, light: Palette.darkBlue),
          style: AppTextStyle.semiBold_20,
        ),
        Padding(
            padding: labelAboveField != null
                ? EdgeInsets.only(top: 10.h)
                : EdgeInsets.zero,
            child: FormBuilderTextField(
              name: keyName,
              validator: validator,
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: contentPadding ??
                      EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 17.w,
                      ),
                  hintText: hintText,
                  hintStyle: hintStyle,
                  suffixIcon: suffixIcon),
            )),
      ],
    );
  }
}
