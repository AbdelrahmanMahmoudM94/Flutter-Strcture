// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_structure/features/common/extensions/size_extensions.dart';
import 'package:flutter_structure/features/common/helper/language_helper.dart';
import 'package:flutter_structure/features/common/utility/palette.dart';
import 'package:flutter_structure/features/common/utility/theme.dart';
import 'package:flutter_structure/features/shared/widgets/app_text.dart';

class CustomRadioButton<T> extends StatefulWidget {
  const CustomRadioButton({
    required this.list,
    required this.keyName,
    this.isVertical = false,
    this.arrowVisible = false,
    this.disableField = false,
    this.selectedTextColor,
    this.selectedBorder,
    this.unselectedBorderColor,
    this.background,
    this.internalPadding,
    this.initialValue,
    this.onOptionSelected,
    this.initialSelectedIndex,
    this.onChanged,
    required this.customFormKey,
    this.validator,
    this.textColor,
    this.reset = false,
  });
  final List<SelectionButtonParams<T>> list;
  final String keyName;
  final T? initialValue;
  final bool? isVertical;
  final Color? selectedTextColor;
  final Color? selectedBorder;
  final Color? unselectedBorderColor;
  final Color? background;
  final Color? textColor;
  final EdgeInsets? internalPadding;
  final bool? arrowVisible;
  final int? initialSelectedIndex;
  final bool? disableField;
  final String? Function(T?)? validator;
  final GlobalKey<FormBuilderState>? customFormKey;
  final bool reset;
  final Function(
    FormFieldState<T> field,
    int selectedIndex,
  )? onOptionSelected;

  final void Function(T?)? onChanged;
  @override
  State<CustomRadioButton<T>> createState() => _CustomRadioButtonState<T>();
}

class _CustomRadioButtonState<T> extends State<CustomRadioButton<T>> {
  int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return widget.isVertical!
        ? _buildVerticalRadioButtons()
        : _buildHorizontalRadioButtons();
  }

  @override
  void initState() {
    super.initState();
    selectIndex = widget.initialSelectedIndex ?? 0;
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      if (widget.initialValue != null) {
        widget.customFormKey!.currentState!.fields[widget.keyName]
            ?.didChange(widget.initialValue as T);
      }
    });
  }

  Widget _buildHorizontalRadioButtons() {
    if (widget.reset) {
      selectIndex = widget.initialSelectedIndex ?? 0;
    }
    return FormBuilderField<T>(
      name: widget.keyName,
      validator: widget.validator,
      initialValue: widget.initialValue,
      enabled: !(widget.disableField ?? false),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<T> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.list
                    .mapIndexed(
                      (int index, SelectionButtonParams<T> e) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: InkWell(
                          onTap: () {
                            if (!widget.disableField!) {
                              selectIndex = index;
                              //setState(() {});
                              field.didChange(e.value);
                              if (widget.onOptionSelected != null) {
                                widget.onOptionSelected!(
                                  field,
                                  selectIndex,
                                );
                              }
                              if (widget.onChanged != null) {
                                widget.onChanged?.call(
                                  widget.list[selectIndex].value,
                                );
                              }
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.isDarkMode(context)
                                  ? Palette.semiLightBlack
                                  : widget.background ?? Colors.transparent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r)),
                              border: selectIndex == index
                                  ? Border.all(
                                      color: widget.selectedBorder ??
                                          Palette.primaryColor,
                                    )
                                  : Border.all(
                                      color: widget.unselectedBorderColor ??
                                          Palette.semiLightGrey,
                                    ),
                            ),
                            padding: widget.internalPadding ??
                                EdgeInsets.symmetric(
                                  horizontal: 15.w,
                                  vertical: 8.h,
                                ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 15.w,
                                      height: 15.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: selectIndex == index
                                            ? AppTheme.isDarkMode(context)
                                                ? Palette.white
                                                : Palette.black
                                            : Palette.greyDivider
                                                .withOpacity(0.3),
                                      ),
                                    ),
                                    16.widthBox,
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 4.h),
                                      child: Text(
                                        e.text,
                                        style:
                                            TextStyle(color: widget.textColor),
                                      ),
                                    ),
                                  ],
                                ),
                                widget.arrowVisible!
                                    ? 50.widthBox
                                    : Container(),
                                widget.arrowVisible!
                                    ? FaIcon(
                                        LanguageHelper.isAr(context)
                                            ? FontAwesomeIcons.arrowLeft
                                            : FontAwesomeIcons.arrowRight,
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            if (field.hasError)
              Text(
                field.errorText!,
                style: TextStyle(color: Palette.darkRed),
              ),
          ],
        );
      },
    );
  }

  Widget _buildVerticalRadioButtons() {
    return FormBuilderField<T>(
      name: widget.keyName,
      initialValue: widget.initialValue,
      enabled: !widget.disableField!,
      builder: (FormFieldState<T> field) {
        return Column(
          children: widget.list
              .mapIndexed(
                (int index, SelectionButtonParams<T> e) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.w),
                  child: InkWell(
                    onTap: () {
                      selectIndex = index;
                      setState(() {});
                      field.didChange(e.value);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.isDarkMode(context)
                            ? Palette.semiLightBlack
                            : widget.background ?? Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(10.r)),
                        border: selectIndex == index
                            ? Border.all(
                                color: widget.selectedBorder ??
                                    Palette.bondiBlueColor,
                              )
                            : Border.all(
                                color: widget.unselectedBorderColor ??
                                    Palette.semiLightGrey,
                              ),
                      ),
                      padding: widget.internalPadding ??
                          EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 2.h,
                          ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: 15.w,
                                height: 15.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: selectIndex == index
                                      ? AppTheme.isDarkMode(context)
                                          ? Palette.white
                                          : Palette.black
                                      : Palette.greyDivider.withOpacity(0.3),
                                ),
                              ),
                              20.widthBox,
                              Padding(
                                padding: EdgeInsets.only(bottom: 4.h),
                                child: SizedBox(
                                  width: 300.w,
                                  child: AppText(
                                    text: e.text,
                                    style: AppTextStyle.medium_20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          widget.arrowVisible!
                              ? FaIcon(
                                  LanguageHelper.isAr(context)
                                      ? FontAwesomeIcons.arrowLeft
                                      : FontAwesomeIcons.arrowRight,
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class SelectionButtonParams<T> {
  final String text;
  final T value;
  SelectionButtonParams({
    required this.text,
    required this.value,
  });
}
