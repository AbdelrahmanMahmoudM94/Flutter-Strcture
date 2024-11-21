import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_structure/features/common/utility/palette.dart';
import 'package:flutter_structure/features/common/utility/theme.dart';
 
import '../../common/helper/language_helper.dart';

enum AppFontWeight { bold, normal, medium }

class AppText extends StatelessWidget {
  const AppText({
    super.key,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.fontSize,
    this.translationKey,
    this.text,
    this.textAr,
    this.textEn,
    this.textLimit,
    this.fontWeight,
    this.textColor,
    this.style,
    this.lineHeight,
    this.substringForDots,
    this.displayToolTip = false,
  });
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final bool? softWrap;

  final TextOverflow? overflow;
  final int? maxLines;
  final num? fontSize;
  final String? translationKey;
  final String? text;
  final String? textAr;
  final String? textEn;
  final int? textLimit;
  final int? substringForDots;
  final AppFontWeight? fontWeight;
  final Color? textColor;
  final double? lineHeight;
  final AppTextStyle? style;
  final bool? displayToolTip;

  @override
  Widget build(BuildContext context) {
    return displayToolTip!
        ? Tooltip(
            message: text ?? (LanguageHelper.isAr(context) ? textAr : textEn),
            triggerMode: TooltipTriggerMode.tap,
            child: Text(
              _handleText(context: context),
              style: _handleCustomStyle(context),
              maxLines: maxLines,
              overflow: overflow,
              softWrap: softWrap,
              textAlign: textAlign,
            ),
          )
        : Text(
            _handleText(context: context),
            style: _handleCustomStyle(context),
            maxLines: maxLines,
            overflow: overflow,
            softWrap: softWrap,
            textAlign: textAlign,
          );
  }

  TextStyle _handleCustomStyle(BuildContext context) {
    switch (style) {
      case AppTextStyle.regular_10:
        return TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 10.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.regular_11:
        return TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 11.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.regular_12:
        return TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.regular_13:
        return TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 13.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.regular_14:
        return TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.regular_15:
        return TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.regular_16:
        return TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.regular_17:
        return TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 17.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.regular_18:
        return TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 18.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.regular_19:
        return TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 19.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.regular_20:
        return TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 20.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.regular_21:
        return TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 21.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.regular_24:
        return TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 24.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.regular_28:
        return TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 28.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.regular_36:
        return TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 36.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.regular_48:
        return TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 48.sp,
          color: textColor,
          height: lineHeight,
        );

      case AppTextStyle.medium_10:
        return TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 10.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.medium_11:
        return TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 11.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.medium_12:
        return TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.medium_13:
        return TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 13.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.medium_14:
        return TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.medium_15:
        return TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.medium_16:
        return TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.medium_17:
        return TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 17.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.medium_18:
        return TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.medium_19:
        return TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.medium_20:
        return TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.medium_21:
        return TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 21.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.medium_24:
        return TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 24.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.medium_28:
        return TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 28.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.medium_36:
        return TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 36.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.medium_48:
        return TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 48.sp,
          color: textColor,
          height: lineHeight,
        );

      case AppTextStyle.semiBold_10:
        return TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 10.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.semiBold_11:
        return TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 11.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.semiBold_12:
        return TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.semiBold_13:
        return TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.semiBold_14:
        return TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.semiBold_15:
        return TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.semiBold_16:
        return TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.semiBold_17:
        return TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 17.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.semiBold_18:
        return TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.semiBold_19:
        return TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 19.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.semiBold_20:
        return TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.semiBold_21:
        return TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 21.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.semiBold_24:
        return TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 24.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.semiBold_28:
        return TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 28.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.semiBold_36:
        return TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 36.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.semiBold_48:
        return TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 48.sp,
          color: textColor,
          height: lineHeight,
        );

      case AppTextStyle.bold_10:
        return TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 10.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.bold_11:
        return TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 11.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.bold_12:
        return TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.bold_13:
        return TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.bold_14:
        return TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.bold_15:
        return TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 15.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.bold_16:
        return TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.bold_17:
        return TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 17.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.bold_18:
        return TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 18.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.bold_19:
        return TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 19.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.bold_20:
        return TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.bold_21:
        return TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 21.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.bold_22:
        return TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 22.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.bold_23:
        return TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 23.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.bold_24:
        return TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 24.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.bold_28:
        return TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 28.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.bold_36:
        return TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 36.sp,
          color: textColor,
          height: lineHeight,
        );
      case AppTextStyle.bold_48:
        return TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 48.sp,
          color: textColor,
          height: lineHeight,
        );

      default:
        return TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: fontSize?.sp ?? 16.sp,
            color: textColor ??
                AppTheme.inDarkMode(context,
                    light: Palette.black, dark: Palette.white));
    }
  }

  String _handleText({
    required BuildContext context,
  }) {
    if (text != null) {
      if (textLimit != null) {
        if (text!.trim().length > textLimit!) {
          final String textVal = text!.trim().substring(0, textLimit);
          if (substringForDots != null) {
            return "${textVal.substring(0, textVal.length - substringForDots!)}...";
          }
          return textVal;
        } else {
          return text!.trim();
        }
      } else {
        return text!.trim();
      }
    } else if (translationKey != null) {
      return context.tr(translationKey!);
    } else if (LanguageHelper.isAr(context)) {
      if (textAr == null) {
        return "";
      } else {
        if (textLimit != null) {
          if (textAr!.trim().length > textLimit!) {
            final String textVal = textAr!.trim().substring(0, textLimit);
            if (substringForDots != null) {
              return "${textVal.substring(0, textVal.length - substringForDots!)}...";
            }
            return textVal;
          } else {
            return textAr!.trim();
          }
        } else {
          return textAr!.trim();
        }
      }
    } else if (LanguageHelper.isEN(context)) {
      if (textEn == null) {
        return "";
      } else {
        if (textLimit != null) {
          if (textEn!.trim().length > textLimit!) {
            final String textVal = textEn!.trim().substring(0, textLimit);
            if (substringForDots != null) {
              return "${textVal.substring(0, textVal.length - substringForDots!)}...";
            }
            return textVal;
          } else {
            return textEn!.trim();
          }
        } else {
          return textEn!.trim();
        }
      }
    }
    return "";
  }
}

enum AppTextStyle {
  regular_10,
  regular_11,
  regular_12,
  regular_13,
  regular_14,
  regular_15,
  regular_16,
  regular_17,
  regular_18,
  regular_19,
  regular_20,
  regular_21,
  regular_24,
  regular_28,
  regular_36,
  regular_48,
  medium_10,
  medium_11,
  medium_12,
  medium_13,
  medium_14,
  medium_15,
  medium_16,
  medium_17,
  medium_18,
  medium_19,
  medium_20,
  medium_21,
  medium_24,
  medium_28,
  medium_36,
  medium_48,
  semiBold_10,
  semiBold_11,
  semiBold_12,
  semiBold_13,
  semiBold_14,
  semiBold_15,
  semiBold_16,
  semiBold_17,
  semiBold_18,
  semiBold_19,
  semiBold_20,
  semiBold_21,
  semiBold_22,
  semiBold_23,
  semiBold_24,
  semiBold_28,
  semiBold_36,
  semiBold_48,
  bold_10,
  bold_11,
  bold_12,
  bold_13,
  bold_14,
  bold_15,
  bold_16,
  bold_17,
  bold_18,
  bold_19,
  bold_20,
  bold_21,
  bold_22,
  bold_23,
  bold_24,
  bold_28,
  bold_36,
  bold_48,
}
