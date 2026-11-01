import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import 'file_picker_config.dart';
import 'file_picker_item.dart';

part 'custom_file_picker_state.dart';

/// Holds the files picked from the file browser, gallery or camera.
/// Picking adds to the current list; a cancelled pick keeps it unchanged.
/// Create it directly (`CustomFilePickerCubit()`) or provide it from your DI.
class CustomFilePickerCubit extends Cubit<CustomFilePickerState> {
  CustomFilePickerCubit() : super(const CustomFilePickerInitialState());

  static const int defaultMaxBytes = 5 * 1024 * 1024;

  List<FilePickerItem> get files => state is CustomFilePickerReadyState
      ? List<FilePickerItem>.from((state as CustomFilePickerReadyState).files)
      : <FilePickerItem>[];

  // Accepts "pdf", ".pdf" or a file name like "a.PDF" and returns "pdf".
  String _normalizeExt(String? value) {
    final String v = (value ?? '').trim().toLowerCase();
    final int dot = v.lastIndexOf('.');
    return dot == -1 ? v : v.substring(dot + 1);
  }

  bool _isAllowedExt(String ext, List<String>? allowedExtensions) {
    if (allowedExtensions == null || allowedExtensions.isEmpty) return true;
    return allowedExtensions.map(_normalizeExt).contains(_normalizeExt(ext));
  }

  CustomFileType _mapFileType(FileType filetype) => switch (filetype) {
        FileType.audio => CustomFileType.audio,
        FileType.video => CustomFileType.video,
        FileType.image => CustomFileType.image,
        _ => CustomFileType.file,
      };

  String _keyForItem(FilePickerItem item) =>
      '${item.file.path}|${item.file.name}|${item.size}';

  /// Picks from the file browser (or the gallery with [FileType.image]).
  /// [fileSize] is the per-file limit in bytes (default 5 MB). With
  /// [allowMultiple] false a new pick replaces the single current file.
  Future<void> pickFile({
    FileType filetype = FileType.any,
    List<String>? allowedExtensions,
    bool allowMultiple = false,
    num? fileSize,
    int? maximumFiles,
  }) async {
    try {
      final List<PlatformFile> picked = await FilePicker.pickFiles(
        type: filetype,
        allowedExtensions: filetype == FileType.custom
            ? allowedExtensions?.map(_normalizeExt).toList()
            : null,
      );
      final List<FilePickerItem> existing = files;
      if (picked.isEmpty) {
        emit(CustomFilePickerReadyState(files: existing));
        return;
      }

      final int maxBytes = (fileSize ?? defaultMaxBytes).toInt();
      final List<FilePickerItem> newItems = <FilePickerItem>[];
      FilePickerErrorType? rejection;
      for (final PlatformFile pf in allowMultiple ? picked : picked.take(1)) {
        final int size = await pf.length() ?? 0;
        if (!_isAllowedExt(pf.name, allowedExtensions)) {
          rejection ??= FilePickerErrorType.invalidType;
          continue;
        }
        if (size > maxBytes) {
          rejection ??= FilePickerErrorType.fileTooLarge;
          continue;
        }
        newItems.add(FilePickerItem(
          file: pf.xFile,
          size: size,
          fileType: _mapFileType(filetype),
        ));
      }
      if (newItems.isEmpty) {
        emit(CustomFilePickerErrorState(
          type: rejection ?? FilePickerErrorType.invalidType,
        ));
        return;
      }

      _merge(
        existing: allowMultiple ? existing : <FilePickerItem>[],
        added: newItems,
        maximumFiles: maximumFiles,
      );
    } catch (_) {
      emit(const CustomFilePickerErrorState(
        type: FilePickerErrorType.pickFailed,
      ));
    }
  }

  Future<void> pickCamera({int? maximumFiles, num? fileSize}) =>
      _pickFromCamera(
          video: false, maximumFiles: maximumFiles, fileSize: fileSize);

  Future<void> pickVideoCamera({int? maximumFiles, num? fileSize}) =>
      _pickFromCamera(
          video: true, maximumFiles: maximumFiles, fileSize: fileSize);

  Future<void> _pickFromCamera({
    required bool video,
    int? maximumFiles,
    num? fileSize,
  }) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? shot = video
          ? await picker.pickVideo(source: ImageSource.camera)
          : await picker.pickImage(source: ImageSource.camera);
      if (shot == null) return;
      final int size = await shot.length();
      if (size > (fileSize ?? defaultMaxBytes)) {
        emit(const CustomFilePickerErrorState(
          type: FilePickerErrorType.fileTooLarge,
        ));
        return;
      }
      _merge(
        existing: files,
        added: <FilePickerItem>[
          FilePickerItem(
            file: shot,
            size: size,
            fileType: video ? CustomFileType.video : CustomFileType.image,
          ),
        ],
        maximumFiles: maximumFiles,
      );
    } catch (_) {
      emit(const CustomFilePickerErrorState(
        type: FilePickerErrorType.pickFailed,
      ));
    }
  }

  // Appends [added] to [existing] without duplicates and applies the cap.
  void _merge({
    required List<FilePickerItem> existing,
    required List<FilePickerItem> added,
    int? maximumFiles,
  }) {
    final Set<String> keys = existing.map(_keyForItem).toSet();
    List<FilePickerItem> merged = <FilePickerItem>[
      ...existing,
      ...added.where((FilePickerItem i) => !keys.contains(_keyForItem(i))),
    ];
    bool isExceed = false;
    if (maximumFiles != null && merged.length > maximumFiles) {
      merged = merged.sublist(0, maximumFiles);
      isExceed = true;
    }
    emit(CustomFilePickerReadyState(files: merged, isExceed: isExceed));
  }

  /// Seeds the list with files that are already on the record.
  void setFiles(List<FilePickerItem>? initialFiles) {
    emit(CustomFilePickerReadyState(
      files: (initialFiles ?? <FilePickerItem>[]).map((FilePickerItem e) {
        e.isUploaded = true;
        return e;
      }).toList(),
    ));
  }

  void remove(int index) {
    final List<FilePickerItem> current = files;
    if (index < 0 || index >= current.length) return;
    current.removeAt(index);
    emit(CustomFilePickerReadyState(files: current, isDelete: true));
  }
}
