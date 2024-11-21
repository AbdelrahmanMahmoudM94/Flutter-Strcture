import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_text.dart';
import 'check_box_cubit.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    Key? key,
    required this.checkboxCubit,
    required this.index,
    this.label,
    this.richTextWidget,
  }) : super(key: key);
  final CheckboxCubit checkboxCubit;
  final String? label;
  final int index;
  final Text? richTextWidget;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckboxCubit, Map<int, bool>>(
      bloc: checkboxCubit,
      builder: (BuildContext context, Map<int, bool> state) {
        bool isChecked = state[index] ?? false;

        return Row(
          children: <Widget>[
            Checkbox(
              value: isChecked,
              onChanged: (bool? value) {
                checkboxCubit.toggleCheckbox(index);
              },
            ),
            label == null
                ? SizedBox()
                : Flexible(
                    child: AppText(
                      style: AppTextStyle.regular_16,
                      text: label,
                    ),
                  ),
            richTextWidget == null
                ? SizedBox()
                : Flexible(child: richTextWidget!)
          ],
        );
      },
    );
  }
}
