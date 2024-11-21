import 'package:flutter_bloc/flutter_bloc.dart';

class ToggleCubit extends Cubit<Map<String, bool>> {
  ToggleCubit() : super(<String, bool>{});

  // Toggle the value of a specific toggle identified by its key
  void toggle(String key, bool value) {
    final Map<String, bool> newState = Map<String, bool>.from(state);
    newState[key] = value;
    emit(newState); // Emit new state with the updated toggle
  }

  // Get the value for a specific toggle
  bool getValue(String key) {
    return state[key] ?? false; // Default to false if not set
  }
}
