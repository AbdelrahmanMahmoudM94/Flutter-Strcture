import 'package:flutter_structure/features/common/extensions/size_extensions.dart';
import 'package:flutter_structure/features/shared/widgets/app_text.dart';
 import 'package:material_ui/material_ui.dart';

class BulletPoint extends StatelessWidget {
  const BulletPoint({super.key, required this.text, this.showBullet = true});
  final String text;

  /// Pass `false` when there is only a single item.
  final bool showBullet;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (showBullet) ...<Widget>[
          AppText(text: "• ", style: AppTextStyle.semiBold_16),
          5.widthBox,
        ],
        Expanded(
          child: AppText(text: text, style: AppTextStyle.semiBold_16),
        ),
      ],
    );
  }
}
