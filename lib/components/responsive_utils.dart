import 'dart:math';

import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/constants.dart';

extension ResponsiveSize on BuildContext {
  double calculateResponsiveSize() {
    var size = MediaQuery.sizeOf(this);

    return min(1, size.width / (cardWidth * 14));
  }
}
