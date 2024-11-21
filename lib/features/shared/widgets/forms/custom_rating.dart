// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_structure/features/common/extensions/size_extensions.dart';
import 'package:flutter_structure/features/common/utility/palette.dart';
import 'package:flutter_structure/features/shared/widgets/app_text.dart';
import 'package:flutter_structure/features/shared/widgets/forms/drop_down_field.dart';

class CustomRating extends StatefulWidget {
  const CustomRating(
      {required this.keyName,
      this.isVertical = false,
      this.disableField = false,
      this.initialValue,
      this.customFormKey,
      this.colorBar,
      this.validator,
      this.numberOfRateBar,
      this.allowHalfRating = false,
      this.ratingFactors});

  final String keyName;
  final double? initialValue;
  final bool? isVertical;
  final bool? allowHalfRating;
  final Color? colorBar;
  final int? numberOfRateBar;

  final bool? disableField;
  final String? Function(double?)? validator;
  final GlobalKey<FormBuilderState>? customFormKey;
  final List<String>? ratingFactors;

  @override
  State<CustomRating> createState() => _CustomRatingState<CustomRating>();
}

class _CustomRatingState<T> extends State<CustomRating> {
  int selectIndex = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      if (widget.initialValue != null) {
        widget.customFormKey?.currentState?.fields[widget.keyName]!
            .didChange(widget.initialValue);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<double>(
      name: widget.keyName,
      validator: widget.validator,
      initialValue: widget.initialValue,
      enabled: !widget.disableField!,
      builder: (FormFieldState<double> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            widget.ratingFactors != null
                ? RatingBar.builder(
                    initialRating: widget.initialValue ?? 0,
                    ignoreGestures: widget.disableField!,
                    direction:
                        widget.isVertical! ? Axis.vertical : Axis.horizontal,
                    allowHalfRating: widget.allowHalfRating!,
                    itemCount: widget.ratingFactors?.length ?? 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 12.w),
                    itemBuilder: (BuildContext context, int index) => Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          size: 40.w,
                          color: widget.colorBar ?? Colors.amber,
                        ),
                        Positioned(
                          top: 40.h,
                          child: SizedBox(
                            width: 50.w,
                            child: AppText(
                              text: widget.ratingFactors![index],
                              textAlign: TextAlign.center,
                              style: AppTextStyle.regular_12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onRatingUpdate: (double rating) {
                      field.didChange(rating);
                    },
                  )
                : RatingBar.builder(
                    initialRating: widget.initialValue ?? 0,
                    ignoreGestures: widget.disableField!,
                    direction:
                        widget.isVertical! ? Axis.vertical : Axis.horizontal,
                    allowHalfRating: widget.allowHalfRating!,
                    itemCount: widget.numberOfRateBar ?? 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (BuildContext context, _) => Column(
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: widget.colorBar ?? Colors.amber,
                        ),
                      ],
                    ),
                    onRatingUpdate: (double rating) {
                      field.didChange(rating);
                    },
                  ),
            if (field.hasError)
              AppText(
                  textColor: Palette.darkRed,
                  text: field.errorText!,
                  style: AppTextStyle.medium_15),
          ],
        );
      },
    );
  }
}
