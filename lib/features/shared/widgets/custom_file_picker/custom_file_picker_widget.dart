import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_structure/features/common/extensions/size_extensions.dart';
import 'package:flutter_structure/features/common/utility/palette.dart';
import 'package:flutter_structure/features/shared/widgets/custom_elevated_button_widget.dart';
import 'package:flutter_structure/features/shared/widgets/custom_file_picker/custom_file_picker_cubit.dart';

class GenericFilePicker extends StatelessWidget {
  const GenericFilePicker({
    Key? key,
    required this.filePickerCubit,
    this.isFromCamera = false,
    this.isFromGallery = false,
    this.isFromFile = false,
    this.keyName = 'file',
  }) : super(key: key);
  final FilePickerCubit filePickerCubit;
  final bool isFromCamera;
  final bool isFromGallery;
  final bool isFromFile;
  final String keyName;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilePickerCubit, List<XFile>>(
      bloc: filePickerCubit,
      builder: (BuildContext context, List<XFile> state) {
        return FormBuilderField<String>(
          name: keyName,
          initialValue: state.isNotEmpty ? state.first.path : '',
          builder: (FormFieldState<String> field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (isFromCamera)
                  CustomElevatedButton(
                    backgroundColor: Palette.primaryColor,
                    onPressed: () {
                      filePickerCubit.pickCamera();
                    },
                    text: context.tr('takePhoto'),
                  ),
                20.heightBox,
                if (isFromGallery)
                  CustomElevatedButton(
                    backgroundColor: Palette.primaryColor,
                    onPressed: () {
                      filePickerCubit.pickFile(
                        filetype: FileType.image,
                      );
                    },
                    text: context.tr('choosePhoto'),
                  ),
                20.heightBox,
                if (isFromFile)
                  CustomElevatedButton(
                    backgroundColor: Palette.primaryColor,
                    onPressed: () {
                      filePickerCubit.pickFile();
                    },
                    text: context.tr('chooseFile'),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
