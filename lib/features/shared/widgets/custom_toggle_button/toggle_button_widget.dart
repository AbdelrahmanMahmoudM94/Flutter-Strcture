import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../di/toggle_button_model.dart';
import '../app_text.dart';
import 'custom_toggle_button_cubit.dart';

class CustomToggleWidget extends StatelessWidget {
  const CustomToggleWidget(
      {Key? key,
      required this.title,
      required this.keyValue,
      required this.toggleCubit,
      required this.toggleModel,
      required this.onToggle,
      required this.thumbIcon})
      : super(key: key);

  final String title;
  final String keyValue;
  final ToggleCubit toggleCubit;
  final ToggleModel toggleModel;
  final Function onToggle;
  final Icon thumbIcon;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: BlocBuilder<ToggleCubit, Map<String, bool>>(
        bloc: toggleCubit,
        builder: (BuildContext context, Map<String, bool> state) {
          return SwitchListTile(
            secondary: thumbIcon,
//thumbIcon: thumbIcon,
            title: AppText(
              text: title,
              style: AppTextStyle.semiBold_14,
            ),
            value: toggleCubit.getValue(keyValue),
            onChanged: (bool value) {
              // Set the new value in SharedPreferences and update the cubit
              toggleModel.setValue(keyValue, value);
              onToggle(value);
            },
          );
        },
      ),
    );
  }
}
