import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/helper/language_helper.dart';
import '../../../common/utility/palette.dart';
import '../../../common/utility/theme.dart';
import '../app_text.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget(
      {super.key,
      required this.keyName,
      this.validator,
      this.hintText,
      this.hintStyle,
      this.suffixIcon,
      this.contentPadding,
      this.labelAboveField,
      this.maxLines,
      this.prefixIcon,
      this.initalValue,
      this.controller,
      this.readOnly = false,
      this.align,
      this.textDirection,
      this.maxLength});
  final String keyName;
  final String? labelAboveField;
  final String? hintText;
  final String? initalValue;
  final String? Function(String?)? validator;
  final TextStyle? hintStyle;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLines;
  final TextEditingController? controller;
  final bool readOnly;
  final TextAlign? align;
  final TextDirection? textDirection;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (labelAboveField != null)
          AppText(
            text: labelAboveField,
            textColor: AppTheme.inDarkMode(context,
                dark: Palette.white, light: Palette.darkBlue),
            style: AppTextStyle.semiBold_18,
          ),
        Padding(
          padding: labelAboveField != null
              ? EdgeInsets.only(top: 10.h)
              : EdgeInsets.zero,
          child: FormBuilderTextField(
            textAlign: align ?? TextAlign.start,
            textDirection: textDirection ??
                (LanguageHelper.isAr(context)
                    ? TextDirection.rtl
                    : TextDirection.ltr),
            readOnly: readOnly,
            maxLines: maxLines ?? 1,
            name: keyName,
            maxLength: maxLength,
            controller: controller,
            validator: validator,
            initialValue: initalValue,
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: contentPadding ??
                    EdgeInsets.symmetric(
                      vertical: 18.h,
                      horizontal: 17.w,
                    ),
                hintText: hintText,
                hintStyle: hintStyle,
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon),
          ),
        ),
      ],
    );
  }
}
