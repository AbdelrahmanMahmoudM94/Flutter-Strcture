import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_structure/features/common/helper/app_validator.dart';
import 'package:flutter_structure/features/common/utility/palette.dart';
import 'package:flutter_structure/features/common/utility/theme.dart';

class TextLabel extends StatefulWidget {
  const TextLabel({
    this.controller,
    this.hintText,
    this.iconPath,
    this.onIconPressed,
    this.width,
    this.height,
    this.validator,
    this.backgroundColor,
    this.fieldName = "",
    super.key,
    this.textInputType,
    this.disableEditingTextFiled = false,
    this.inputFormatters,
    this.onTap,
    this.margin,
    this.marginWidth,
    this.enableBorder = false,
    this.fromDateTimePicker = false,
    this.borderColor,
    this.inputTextStyle,
    this.hintStyle,
    this.initialValue,
    this.unFocus,
    this.preventStylingForReadOnly = false,
    this.notRequired = false,
    this.applyInputFormatters = true,
    this.suffix,
    this.onChanged,
    this.iconHeight,
    this.iconColor,
    this.maxLines,
    this.maxLength,
    this.suffixText,
  });
  final TextEditingController? controller;
  final String? hintText;
  final String? iconPath;
  final bool? disableEditingTextFiled;
  final bool? notRequired;
  final String? fieldName;
  final VoidCallback? onIconPressed;
  final double? width;
  final double? height;
  final String? Function(String?)? validator;
  final Color? backgroundColor;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final Function()? onTap;
  final double? marginWidth;
  final EdgeInsets? margin;
  final bool enableBorder;
  final Color? borderColor;
  final TextStyle? hintStyle;
  final TextStyle? inputTextStyle;
  final String? initialValue;
  final String? suffixText;
  final bool? fromDateTimePicker;
  final bool? preventStylingForReadOnly;
  final Widget? suffix;
  final bool applyInputFormatters;
  final Function()? unFocus;
  final Function(String?)? onChanged;
  final double? iconHeight;
  final Color? iconColor;
  final int? maxLines;
  final int? maxLength;
  @override
  State<TextLabel> createState() => _TextLabelState();
}

class _TextLabelState extends State<TextLabel> {
  final FocusNode focusNode = FocusNode();
  bool hasError = false;
  @override
  void initState() {
    super.initState();

    if (widget.unFocus != null) {
      focusNode.addListener(() {
        if (!focusNode.hasFocus) {
          widget.unFocus!();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.w),
        ),
        width: widget.width,
        height: hasError ? ((widget.height ?? 50.h) + 20.h) : widget.height,
        // constraints: BoxConstraints(
        //   minHeight: widget.height ?? 50.h,
        // ),
        margin: widget.margin ??
            EdgeInsets.symmetric(
              horizontal: widget.marginWidth ?? 35.w,
              vertical: 10.h,
            ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FormBuilderTextField(
            onTap: widget.onTap,
            initialValue: widget.initialValue,
            onChanged: widget.onChanged,
            maxLength: widget.disableEditingTextFiled != null &&
                    widget.disableEditingTextFiled!
                ? null
                : widget.maxLength,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: widget.fieldName!,
            focusNode: widget.unFocus != null ? focusNode : null,
            readOnly: widget.disableEditingTextFiled ?? false,
            validator: widget.validator ??
                (!(widget.disableEditingTextFiled ?? false)
                    ? (widget.notRequired!
                        ? null
                        : (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'emptyError'.tr();
                            }
                            return null;
                          })
                    : null),
            keyboardType: widget.textInputType,
            controller: widget.controller,
            maxLines: widget.maxLines,
            style: widget.inputTextStyle,
            inputFormatters: widget.inputFormatters ??
                (widget.applyInputFormatters
                    ? CustomTextInputFormatter()
                    : null),
            decoration: InputDecoration(
              isDense: true,
              suffixText: widget.suffixText,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: widget.height == null ? 0 : (widget.height! / 4),
                horizontal: 17.w,
              ),
              hintStyle: TextStyle(fontSize: 1),
              suffix: widget.suffix,
              hintText: widget.hintText,
              suffixIcon: widget.iconPath != null &&
                      (widget.iconPath.toString().isNotEmpty)
                  ? IconButton(
                      icon: SvgPicture.asset(
                        widget.iconPath!,
                        height: widget.iconHeight,
                        color: widget.iconColor,
                      ),
                      onPressed: widget.onIconPressed,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
