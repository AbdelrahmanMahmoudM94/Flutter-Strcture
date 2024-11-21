import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class DatePickerCubit extends Cubit<DateTime> {
  DatePickerCubit() : super(DateTime.now());

  void selectDate(DateTime selectedDate) {
    emit(selectedDate);
  }
}
