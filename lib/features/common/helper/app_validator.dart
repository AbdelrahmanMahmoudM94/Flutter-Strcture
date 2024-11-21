import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppValidator {
  static String? validatorRequired(dynamic value, BuildContext context) {
    if (value == null || (value is String && value.trim().isEmpty)) {
      return "emptyError".tr();
    }
    return null;
  }

  static String? validatorAmountRequired(dynamic value, BuildContext context) {
    if (value == null || (value is String && value.trim().isEmpty)) {
      return "emptyError".tr();
    } else if (int.parse(value as String) > 9999998) {
      return "amount-error".tr();
    }
    return null;
  }

  static String? validatorHasLength(
    String? value,
    BuildContext context,
    int length, {
    bool isRequired = true,
  }) {
    if (isRequired) {
      if (value == null || (value.isEmpty)) {
        return "emptyError".tr();
      } else {
        if (value.isNotEmpty && value.length < length) {
          return "chars-len".tr() + " " + length.toString() + " " + "char".tr();
        }
      }
    } else {
      if (value != null && value.isNotEmpty && value.length < length) {
        return "chars-len".tr() + " " + length.toString() + " " + "char".tr();
      }
    }

    return null;
  }

  static String? validatorPasswordRequired(
    String? value,
    BuildContext context,
  ) {
    const String pattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&\*~]).{8,}$';

    final RegExp regExp = RegExp(pattern);
    if (value == null || (value.isEmpty)) {
      return "emptyError".tr();
    } else if (!regExp.hasMatch(value)) {
      return "password-invalid-len".tr();
    }
    return null;
  }

  static String? validatorPhoneNumberRequired(
    String? value,
    BuildContext context, {
    bool isNotRequired = false,
    int? length,
  }) {
    if (isNotRequired &&
        (value == null || value.isEmpty || containsOnlySpaces(value))) {
      return null;
    } else {
      if (value == null || (value.isEmpty)) {
        return "emptyError".tr();
      } else {
        final bool format =
            RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
                    .hasMatch(value) &&
                value.length > (length ?? 5);
        if (format) {
          return null;
        } else {
          return "phone-invalid".tr();
        }
      }
    }
  }

  static bool containsOnlySpaces(String input) {
    return RegExp(r'^\s*$').hasMatch(input);
  }

  static String? validatorEmail(String? value, BuildContext context) {
    const String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

    final RegExp regExp = RegExp(pattern);
    if (value == null || (value.isEmpty)) {
      return "emptyError".tr();
    } else if (!regExp.hasMatch(value)) {
      return "emailError".tr();
    }
    return null;
  }

  static String? validatorEmailAndCheckMatching(
      String? value, String matchValue, BuildContext context) {
    const String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

    final RegExp regExp = RegExp(pattern);
    if (value == null || (value.isEmpty)) {
      return "emptyError".tr();
    } else if (!regExp.hasMatch(value)) {
      return "emailError".tr();
    } else if (value != matchValue) {
      return "email-confirm-text-error".tr();
    }
    return null;
  }

  static String? validatorEmailByComma(String? value, BuildContext context) {
    const String emailRegExp = r'^[\w\.-]+@[\w\.-]+\.\w+$';

    final RegExp regExp = RegExp(
      emailRegExp,
      caseSensitive: false,
    );

    if (value == null || (value.isEmpty)) {
      return "emptyError".tr();
    } else {
      final List<String> emailList = value.split(',');

      for (final String email in emailList) {
        final String trimmedEmail = email.trim();
        if (!regExp.hasMatch(trimmedEmail)) {
          return "invite-new-members-emails-error".tr();
        }
      }
    }
    return null;
  }

  static String? validateLink(String? value, {bool isRequired = true}) {
    final RegExp regex =
        RegExp(r'(https?://)?([\da-z\.-]+)\.([a-z]{2,6})([/\w\.-]*)*/?');

    if (isRequired) {
      if (value != null && value.isEmpty) {
        return "emptyError".tr();
      } else if (value != null && value.isNotEmpty && !regex.hasMatch(value)) {
        return 'invalid-link'.tr();
      }
    } else if (value != null && value.isNotEmpty && !regex.hasMatch(value)) {
      return 'invalid-link'.tr();
    } else if (value != null &&
        value.isNotEmpty &&
        regex.hasMatch(value) &&
        value.length > 150) {
      return 'invalid-link'.tr();
    }
    return null;
  }

  static String? validatorNationalID(
    String? value,
    BuildContext context, {
    bool? isRequired = true,
  }) {
    const String pattern = r"^(1|2)([0-9]{9})$";

    final RegExp regExp = RegExp(pattern);

    if (isRequired!) {
      if (value == null || (value.isEmpty)) {
        return "emptyError".tr();
      } else if (!regExp.hasMatch(value)) {
        return "invalid-national-id".tr();
      }
      return null;
    } else {
      if (value != null && value.isNotEmpty && !regExp.hasMatch(value)) {
        return "invalid-national-id".tr();
      }
      return null;
    }
  }
}

List<TextInputFormatter> ArabicInputFormatter({int? len}) {
  return <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp("[0-9\u0600-\u06FF@_!#()?:-=, ]")),
    LengthLimitingTextInputFormatter(len),
  ];
}

List<TextInputFormatter> EnglishInputFormatter({int? len}) {
  return <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z@_!#()?:-=, ]")),
    LengthLimitingTextInputFormatter(len),
  ];
}

List<TextInputFormatter> CustomTextInputFormatter({int? len}) {
  return <TextInputFormatter>[
    FilteringTextInputFormatter.allow(
      RegExp("[0-9\u0600-\u06FF0-9a-zA-Z@_!.#()?:-=, ]"),
    ),
    LengthLimitingTextInputFormatter(len),
  ];
}
class NoPasteInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If the change is larger than 1 character and the old value is empty, it's a paste operation
    if (newValue.text.length > oldValue.text.length + 1) {
      return oldValue;
    }
    return newValue;
  }
}