import 'package:flutter/foundation.dart';

class CommonUtility {
  static printMsg(dynamic msg) {
    if (kDebugMode) {
      print(msg);
    }
  }
}
