import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformSpecify {
  static bool isAndroid({BuildContext? context}) {
    if (context != null) {
      return Theme.of(context).platform == TargetPlatform.android;
    }

    return defaultTargetPlatform == TargetPlatform.android;
  }
}
