import 'package:flutter/material.dart';

/// Where a file can come from.
enum FilePickerSource { camera, gallery, file }

/// Why a pick was rejected. The widget maps these to [FilePickerLabels].
enum FilePickerErrorType { invalidType, fileTooLarge, pickFailed }

/// Every user-facing string of the picker. Defaults are English; pass
/// translated values (from any l10n solution) to localize.
class FilePickerLabels {
  const FilePickerLabels({
    this.title,
    this.hint,
    this.attach = 'Attach files',
    this.optional = 'Optional',
    this.allowedTypes = 'Allowed types:',
    this.maxSize = 'Maximum size:',
    this.megaUnit = 'MB',
    this.maxFilesLimit = _defaultMaxFiles,
    this.requiredError = 'This field is required',
    this.invalidType = 'This file type is not allowed',
    this.fileTooLarge = 'The file is too large',
    this.pickFailed = 'Could not pick the file',
    this.takePhoto = 'Take a photo',
    this.choosePhoto = 'Choose from gallery',
    this.chooseFile = 'Choose a file',
    this.removeAttachment = 'Remove attachment',
  });

  static String _defaultMaxFiles(int max) => 'Maximum $max files';

  final String? title;
  final String? hint;
  final String attach;
  final String optional;
  final String allowedTypes;
  final String maxSize;
  final String megaUnit;
  final String Function(int max) maxFilesLimit;
  final String requiredError;
  final String invalidType;
  final String fileTooLarge;
  final String pickFailed;
  final String takePhoto;
  final String choosePhoto;
  final String chooseFile;
  final String removeAttachment;

  String errorMessage(FilePickerErrorType type) => switch (type) {
        FilePickerErrorType.invalidType => invalidType,
        FilePickerErrorType.fileTooLarge => fileTooLarge,
        FilePickerErrorType.pickFailed => pickFailed,
      };

  String sourceLabel(FilePickerSource s) => switch (s) {
        FilePickerSource.camera => takePhoto,
        FilePickerSource.gallery => choosePhoto,
        FilePickerSource.file => chooseFile,
      };
}

/// Visual overrides. Anything left null falls back to the app [Theme].
class FilePickerStyle {
  const FilePickerStyle({
    this.cardColor,
    this.cardBorder,
    this.cardRadius = 28,
    this.cardShadow,
    this.cardPadding = const EdgeInsets.all(20),
    this.dropZoneColor,
    this.dropZoneRadius = 100,
    this.accentColor,
    this.successColor,
    this.errorColor,
    this.titleStyle,
    this.bodyStyle,
    this.captionStyle,
    this.attachIcon = Icons.attach_file,
    this.removeIcon = Icons.close,
    this.imagePreviewSize = 100,
  });

  final Color? cardColor;
  final BoxBorder? cardBorder;
  final double cardRadius;
  final List<BoxShadow>? cardShadow;
  final EdgeInsetsGeometry cardPadding;

  /// Colour of the dashed outline around the "attach" zone.
  final Color? dropZoneColor;
  final double dropZoneRadius;
  final Color? accentColor;
  final Color? successColor;
  final Color? errorColor;
  final TextStyle? titleStyle;
  final TextStyle? bodyStyle;
  final TextStyle? captionStyle;
  final IconData attachIcon;
  final IconData removeIcon;
  final double imagePreviewSize;
}
