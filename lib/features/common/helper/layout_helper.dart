
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum DeviceMode { Mobile, Tablet, Desktop }

class LayoutHelper {
  // Define size breakpoints for mobile and tablet
  static const double _smallMobileBreakpoint = 420.0;
  static const double _mobileBreakpoint = 600.0;
  static const double _tabletBreakpoint = 1500.0;
  static const double _noTopSafeAreaBreakPoint = 24.0;

  // Function to detect device type based on width
  static DeviceMode detectDeviceType() {
    final double widthSize = ScreenUtil().screenWidth;
    if (widthSize <= _mobileBreakpoint) {
      return DeviceMode.Mobile;
    } else if (widthSize < _tabletBreakpoint) {
      return DeviceMode.Tablet;
    } else {
      return DeviceMode.Desktop;
    }
  }

  // Function to check if the device is a mobile
  static bool isMobile() {
    final double widthSize = ScreenUtil().screenWidth;
    return widthSize <= _mobileBreakpoint;
  }

  static bool isLargerMobile() {
    final double widthSize = ScreenUtil().screenWidth;
    return widthSize >= 500 && widthSize <= 600;
  }

  static bool isLargerTablet() {
    final double widthSize = ScreenUtil().screenWidth;
    return widthSize >= 1200 && widthSize <= 1500;
  }

  static bool isSmallMobile() {
    final double widthSize = ScreenUtil().screenWidth;
    return widthSize <= _smallMobileBreakpoint;
  }

  // Function to check if the device is a tablet
  static bool isTablet() {
    final double widthSize = ScreenUtil().screenWidth;
    return widthSize > _mobileBreakpoint && widthSize < _tabletBreakpoint;
  }

  static bool isMobileWithoutTopSafeArea() {
    final double topSafeArea = ScreenUtil().statusBarHeight;
    return topSafeArea <= _noTopSafeAreaBreakPoint;
  }
}
