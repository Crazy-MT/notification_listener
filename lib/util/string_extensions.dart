import 'dart:convert';

import 'package:crypto/crypto.dart';

extension StringUtils on String {
  String? toMD5() {
    return md5.convert(utf8.encode(this)).toString();
  }
}
