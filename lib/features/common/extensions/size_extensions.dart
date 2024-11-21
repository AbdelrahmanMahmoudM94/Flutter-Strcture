import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../pageutil/pageutil.dart';

///define size for screen (width, height and sp for fonts)
extension SizeExtension on double {
  double get w => PageUtil().setWidth(this);

  double get h => PageUtil().setHeight(this);

  double get sp => PageUtil().setSp(this);
}

extension BoxExtension on num {
  Widget get widthBox => SizedBox(
        width: ScreenUtil().setWidth(this is int ? toDouble() : this),
      );

  Widget get heightBox => SizedBox(
        height: ScreenUtil().setHeight(this is int ? toDouble() : this),
      );
}
