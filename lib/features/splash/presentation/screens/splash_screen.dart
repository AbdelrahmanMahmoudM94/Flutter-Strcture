import 'package:auto_route/auto_route.dart';
 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_structure/features/common/utility/palette.dart';
import 'package:flutter_structure/features/shared/widgets/master_widget.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterWidget(
      showDefaultAppBar: false,
      bottomEnableSafeArea: false,
      topEnableSafeArea: false,
      backgroundColor: Palette.transparentColor,
      screenTitle: "",
      showLeading: false,
      showActionsIcon: false,
      widget: SizedBox(
        height: 1.sh,
        child: Image.network(
            fit: BoxFit.cover,
            "https://assets.bucketlistly.blog/sites/5adf778b6eabcc00190b75b1/assets/6075182186d092000b192cee/best-free-travel-images-image-2.jpg"),
      ),
    );
  }
}
