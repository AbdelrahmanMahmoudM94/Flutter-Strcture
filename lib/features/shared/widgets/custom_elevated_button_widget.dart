import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/utility/palette.dart';
import '../../common/utility/theme.dart';
import 'app_text.dart';

class CustomElevatedButton extends StatefulWidget {
  CustomElevatedButton(
      {super.key,
      this.width,
      this.height,
      this.text,
      this.backgroundColor,
      required this.onPressed,
      this.textStyle,
      this.borderColor,
      this.textColor,
      this.radius,
      this.customChild,
      this.elevation,
      this.textLimit,
      this.fontWeight,
      this.fontSize,
      this.applyShadow = false,
      this.removeWidth = false,
      this.offestShadowY = 3,
      this.gradient,
      this.iconColor,
      this.showBorder = false,
      this.buttonStyle});

  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? borderColor;
  final String? text;
  final AppTextStyle? textStyle;
  final Color? textColor;
  void Function() onPressed;
  final double? radius;
  final Widget? customChild;
  final double? elevation;
  final int? textLimit;
  final AppFontWeight? fontWeight;
  final num? fontSize;
  final bool applyShadow;
  final bool removeWidth;
  final double offestShadowY;
  final Gradient? gradient;
  final Color? iconColor;
  final bool showBorder;
  final ButtonStyle? buttonStyle;

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.removeWidth ? null : widget.width ?? 1.sw,
      height: widget.height ?? 50.h,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        gradient: widget.gradient,
        borderRadius: BorderRadius.circular(widget.radius ?? 30.r),
        boxShadow: widget.applyShadow
            ? <BoxShadow>[
                BoxShadow(
                  blurRadius: 6,
                  offset: Offset(0, widget.offestShadowY),
                  color: const Color(0x29000000),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
          style: widget.buttonStyle ??
              ButtonStyle(
                  iconColor: WidgetStateProperty.all(
                    widget.iconColor ?? Palette.primaryBackgroundDarkTheme,
                  ),
                  backgroundColor: WidgetStateProperty.all(
                      widget.backgroundColor != null
                          ? widget.backgroundColor
                          : Palette.primaryColor),
                  elevation: WidgetStateProperty.resolveWith<double>(
                    // As you said you dont need elevation. I'm returning 0 in both case
                    (Set<WidgetState> states) {
                      if (widget.elevation != null) {
                        return widget.elevation!;
                      }
                      return 0; // Defer to the widget's default.
                    },
                  ),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(widget.radius ?? 20.r),
                      side: BorderSide(
                        color: widget.showBorder
                            ? widget.borderColor ??
                                (AppTheme.isDarkMode(context)
                                    ? Palette.black
                                    : Palette.white)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  )),
          onPressed: () {
            FocusManager.instance.primaryFocus!.unfocus();
            widget.onPressed();
          },
          child: widget.customChild ??
              AppText(
                textAlign: TextAlign.center,
                text: widget.text ?? "",
                style: widget.textStyle,
                textColor: widget.textColor ??
                    (widget.backgroundColor != null &&
                            widget.backgroundColor != Palette.transparntColor
                        ? Palette.white
                        : AppTheme.inDarkMode(context,
                            light: widget.backgroundColor ==
                                    Palette.transparntColor
                                ? Palette.black
                                : Palette.white,
                            dark: Palette.white)),
                textLimit: widget.textLimit,
                fontSize: 16,
                fontWeight: widget.fontWeight ?? AppFontWeight.bold,
                lineHeight: 1,
              )),
    );
  }
}
