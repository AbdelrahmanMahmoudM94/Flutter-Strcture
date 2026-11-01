import 'package:image_picker/image_picker.dart';

enum CustomFileType { file, image, video, audio }

/// A file chosen in the picker. [isUploaded] marks files that were already
/// on the record before this session (so they are never re-sent).
class FilePickerItem {
  FilePickerItem({
    required this.file,
    required this.size,
    this.fileType = CustomFileType.file,
    this.isUploaded = false,
  });

  final XFile file;

  /// Size in bytes.
  final int size;
  final CustomFileType fileType;
  bool isUploaded;

  String get name => file.name;

  /// Lower-case extension without the dot, or '' when there is none.
  String get extension {
    final int dot = name.lastIndexOf('.');
    return dot == -1 ? '' : name.substring(dot + 1).toLowerCase();
  }
}
