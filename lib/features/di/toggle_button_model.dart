import '../shared/data/local_data.dart';
import '../shared/widgets/custom_toggle_button/custom_toggle_button_cubit.dart';

class ToggleModel {
  ToggleModel(this.toggleCubit);
  final ToggleCubit toggleCubit;
  List<String> togglesKeys = <String>[
    'secureLoginToggle',
    'allNotificationsToggle',
    'darkLookToggle',
    'languageToggle',
    'actualSystemEnvironmentToggle',
    'fromTheAgencysStaffToggle',
  ];
  // Initialize SharedPreferences
  Future<void> init() async {
    // Load initial states from SharedPreferences
    togglesKeys.forEach((String key) {
      bool value = LocalData().getBool(key) ?? false;
      toggleCubit.toggle(key, value); // Initialize the cubit with saved values
    });
  }

  // Set the value to SharedPreferences and update the cubit
  Future<void> setValue(String key, bool value) async {
    await LocalData().setBool(key, value);
    toggleCubit.toggle(key, value); // Update the cubit state
  }

  // Get the value from SharedPreferences (if needed directly)
  bool getValue(String key) {
    return LocalData().getBool(key) ?? false;
  }
}
