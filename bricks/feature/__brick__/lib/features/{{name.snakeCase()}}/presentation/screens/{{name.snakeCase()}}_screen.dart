// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_structure/features/shared/widgets/app_text.dart';
import 'package:flutter_structure/features/shared/widgets/master_widget.dart';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

 

@RoutePage()
class {{name.pascalcase()}}Screen extends StatefulWidget {
  const {{name.pascalcase()}}Screen({
    super.key,
     
  });
  
  @override
  State<{{name.pascalcase()}}Screen> createState() => _{{name.pascalcase()}}State();
}

class _{{name.pascalcase()}}State extends State<{{name.pascalcase()}}Screen> {
   
  @override
  void initState() {
     
    super.initState();
  }

   
  @override
  Widget build(BuildContext context) {
    return MasterWidget(
      screenTitle: "".tr(),
      screenTitleStyle: AppTextStyle.semiBold_24,
      widget: Container(),
    );
  }
}