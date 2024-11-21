import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CheckboxCubit extends Cubit<Map<int, bool>> {
  CheckboxCubit(bool initialValue) : super(<int, bool>{});

  // void toggle() {
  //   emit(!state);
  // }

  // Get all selected checkboxes
  List<int> getSelectedCheckboxes() {
    return state.entries
        .where((MapEntry<int, bool> entry) =>
            entry.value) // Filter only selected checkboxes
        .map((MapEntry<int, bool> entry) => entry.key) // Return their indices
        .toList();
  }

  // Toggle the checkbox state for a specific index
  void toggleCheckbox(int index) {
    final Map<int, bool> newState = Map<int, bool>.from(state);
    newState[index] = !(newState[index] ?? false); // Toggle the value
    emit(newState); // Emit the updated state
  }
}
