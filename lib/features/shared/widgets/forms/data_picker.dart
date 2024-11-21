// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_structure/features/common/utility/palette.dart';
import 'package:flutter_structure/features/shared/widgets/forms/text_label.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({
    this.hintText,
    this.firstDate,
    this.initialDate,
    this.lastDate,
    this.disableField = false,
    this.initNull = false,
    required this.keyName,
    this.validator,
    this.onChanged,
    required this.customFormKey,
  });
  final String? hintText;
  final String keyName;
  final DateTime? firstDate;
  final DateTime? initialDate;
  final DateTime? lastDate;
  //final TextEditingController controller;
  final String? Function(String?)? validator;
  final GlobalKey<FormBuilderState> customFormKey;
  final bool? disableField;
  final bool? initNull;
  final Function(String?)? onChanged;

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  final TextEditingController _dateController = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return TextLabel(
      fieldName: widget.keyName,
      hintText: widget.hintText ?? "",
      initialValue: widget.initialDate != null
          ? DateFormat("yyyy-MM-dd", "en").format(widget.initialDate!)
          : null,
      enableBorder: true,
      onTap: () async {
        if (!(widget.disableField ?? false)) {
          await _selectDate(context);
        }
      },
      validator: widget.validator,
      disableEditingTextFiled: true,
      onChanged: widget.onChanged,
      borderColor: Palette.borderColorFill,
      fromDateTimePicker: !(widget.disableField ?? false),
      backgroundColor: widget.disableField ?? false
          ? Palette.borderColorFill
          : Palette.semiBlack,
      marginWidth: 0,
      iconPath: "assets/svg/date-outline-badged.svg",
      iconColor: Palette.primaryColor,
      onIconPressed: () async {
        if (!widget.disableField!) {
          await _selectDate(context);
        }
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ??
          widget.initialDate ??
          (widget.initNull! ? null : DateTime.now()),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate:
          widget.lastDate ?? DateTime.now().add(const Duration(days: 365 * 10)),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      _dateController.text =
          DateFormat("yyyy-MM-dd", "en").format(selectedDate!);
      widget.customFormKey.currentState!.fields[widget.keyName]!
          .didChange(DateFormat("yyyy-MM-dd", "en").format(selectedDate!));
    }
  }
}
