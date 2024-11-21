import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@injectable
class FilePickerCubit extends Cubit<List<XFile>> {
  FilePickerCubit() : super(<XFile>[]);

  Future<void> pickFile({
    FileType filetype = FileType.any,
    List<String> allowedExtensions = const <String>[],
    bool allowMultiple = false,
  }) async {
    final FilePickerResult? pickedImage = await FilePicker.platform.pickFiles(
      type: filetype,
      allowedExtensions: allowedExtensions,
      allowMultiple: allowMultiple,
    );
    emit(pickedImage?.xFiles ?? <XFile>[]);
  }

  Future<void> pickCamera({
    FileType filetype = FileType.any,
    List<String> allowedExtensions = const <String>[],
    bool allowMultiple = false,
  }) async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null)
      emit(<XFile>[pickedImage]);
    else
      emit(<XFile>[]);
  }
}
