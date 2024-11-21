import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/utility/palette.dart';
import '../../../common/utility/theme.dart';
import '../app_text.dart';
import '../custom_elevated_button_widget.dart';
import 'custom_date_picker_cubit.dart';

class GenericDatePicker extends StatelessWidget {
  const GenericDatePicker(
      {required this.cubit, required this.title, this.labelAboveField});
  final DatePickerCubit cubit;
  final String title;
  final String? labelAboveField;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatePickerCubit, DateTime>(
      bloc: cubit,
      builder: (BuildContext context, DateTime selectedDate) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (labelAboveField != null)
              AppText(
                text: labelAboveField,
                textColor: AppTheme.inDarkMode(context,
                    dark: Palette.white, light: Palette.darkBlue),
                style: AppTextStyle.semiBold_18,
              ),
            10.verticalSpace,
            CustomElevatedButton(
              backgroundColor: Palette.primaryColor,
              text: title.toString(),
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  cubit.selectDate(pickedDate);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
