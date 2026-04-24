import 'package:flutter/foundation.dart';

/// 記錄非 Flutter 例外的原生錯誤
void recordNativeError(Object error, StackTrace stack) {
  debugPrint('Native error: $error');
}
