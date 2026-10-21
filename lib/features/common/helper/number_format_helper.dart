import 'package:easy_localization/easy_localization.dart';

class NumbersFormatHelper {
 static String numberFormatThousandsSeparator(String number) {
    return NumberFormat.decimalPattern().format(double.parse(number));
  }
}
