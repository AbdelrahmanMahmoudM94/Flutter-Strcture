part of 'custom_file_picker_cubit.dart';

abstract class CustomFilePickerState {
  const CustomFilePickerState();
}

class CustomFilePickerInitialState extends CustomFilePickerState {
  const CustomFilePickerInitialState();
}

class CustomFilePickerReadyState extends CustomFilePickerState {
  const CustomFilePickerReadyState({
    required this.files,
    this.isExceed = false,
    this.isDelete = false,
  });

  final List<FilePickerItem> files;

  /// True when the picked files hit `maximumFiles` and the rest were dropped.
  final bool isExceed;

  /// True when this state came from removing a file, not picking one.
  final bool isDelete;
}

class CustomFilePickerErrorState extends CustomFilePickerState {
  const CustomFilePickerErrorState({required this.type});

  final FilePickerErrorType type;
}
