import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_structure/features/common/utility/theme.dart';
import 'package:flutter_structure/features/shared/widgets/app_text.dart';
 

class ExpandableSection extends StatelessWidget {
  const ExpandableSection(
      {required this.title, required this.children, this.titleIcon});
  final String title;
  final List<Widget> children;
  final IconData? titleIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ExpandablePanel(
        theme: ExpandableThemeData(
          iconColor: AppTheme.inDarkMode(context,
              light: Colors.black, dark: Colors.white),
        ),
        header: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              if (titleIcon != null) Icon(titleIcon),
              if (titleIcon != null) 5.horizontalSpace,
              Flexible(child: AppText(text: title)),
            ],
          ),
        ),
        collapsed: Container(),
        expanded: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: children),
        ),
      ),
    );
  }
}
