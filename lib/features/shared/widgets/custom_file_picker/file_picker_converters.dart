import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import 'file_picker_item.dart';

/// Turns the picked files into the value stored in the form field.
typedef FilePickerConverter<T> = T? Function(List<FilePickerItem> files);

/// A file as base64, for APIs that take the content inline.
class ImageFileBase64 {
  ImageFileBase64({
    this.name,
    this.extension,
    this.image,
    this.content,
    this.attachmentType,
  });

  String? name;
  String? extension;
  String? image;
  String? content;
  String? attachmentType;
}

/// Ready-made [FilePickerConverter]s. Write your own for other shapes.
abstract final class FilePickerConverters {
  /// The picked files as they are (the default for `List<XFile>`).
  static List<XFile>? xFiles(List<FilePickerItem> files) =>
      files.isEmpty ? null : files.map((FilePickerItem i) => i.file).toList();

  static FormData formData(FilePickerItem item, {String key = 'file'}) =>
      FormData.fromMap(<String, dynamic>{
        key: MultipartFile.fromFileSync(item.file.path, filename: item.name),
      });

  /// One multipart body per file, under the field name [key].
  static FilePickerConverter<List<FormData>> formDataList({
    String key = 'file',
  }) =>
      (List<FilePickerItem> files) => files.isEmpty
          ? null
          : files.map((FilePickerItem i) => formData(i, key: key)).toList();

  static FilePickerConverter<FormData> singleFormData({String key = 'file'}) =>
      (List<FilePickerItem> files) =>
          files.isEmpty ? null : formData(files.first, key: key);

  static ImageFileBase64 base64(FilePickerItem item) {
    final String encoded = base64Encode(File(item.file.path).readAsBytesSync());
    final String ext = item.extension;
    return ImageFileBase64(
      name: item.name,
      image: encoded,
      extension: '.$ext',
      attachmentType: 'application/$ext',
      content: '${_dataPrefix(ext)}$encoded',
    );
  }

  static List<ImageFileBase64>? base64List(List<FilePickerItem> files) =>
      files.isEmpty ? null : files.map(base64).toList();

  static ImageFileBase64? singleBase64(List<FilePickerItem> files) =>
      files.isEmpty ? null : base64(files.first);

  static String _dataPrefix(String ext) {
    if (ext == 'jpg' || ext == 'png' || ext == 'jpeg') {
      return 'data:image/$ext;base64,';
    }
    if (ext == 'pdf') return 'data:file/pdf;base64,';
    return '';
  }
}
