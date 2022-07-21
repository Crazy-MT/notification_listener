import 'package:flutter/material.dart';

class R {
  static final anims = _Anims();
  static final icons = _Icons();
  static final images = _Images();
}

class _Anims {
  static const path = 'assets/anims';
  final loading = '$path/loading.zip';
}

class _Icons {
  static const path = 'assets/icons';
  final logo = '$path/logo.svg';
}

class _Images {
  static const path = 'assets/images';
  final logo = '$path/logo.png';
}