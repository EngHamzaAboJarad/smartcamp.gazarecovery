import 'package:flutter/widgets.dart';

/// A simple responsive sizing helper based on a design reference of 375x812.
/// Use SizeConfig.sw(context, value) for width-scaled values,
/// SizeConfig.sh(context, value) for height-scaled values,
/// and SizeConfig.sp(context, value) for scalable sizes for icons/text.
class SizeConfig {
  static const double _baseWidth = 375.0;
  static const double _baseHeight = 812.0;

  static double sw(BuildContext context, double size) {
    final w = MediaQuery.of(context).size.width;
    return w / _baseWidth * size;
  }

  static double sh(BuildContext context, double size) {
    final h = MediaQuery.of(context).size.height;
    return h / _baseHeight * size;
  }

  static double sp(BuildContext context, double size) => sw(context, size);
}

