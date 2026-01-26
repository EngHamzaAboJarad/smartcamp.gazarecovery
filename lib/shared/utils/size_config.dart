import 'package:flutter/widgets.dart';

/// Shared responsive helper based on design 375x812.
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

