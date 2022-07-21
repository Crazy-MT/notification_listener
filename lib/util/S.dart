import 'package:flutter/material.dart';

class S {
  static final colors = _Colors();
  static final textStyles = _TextStyles();
  static final shadows = _Shadows();
}

class _Colors {
  final transparent = Colors.transparent;
  final black = Colors.black;
  final black87 = Colors.black87;
  final white = Colors.white;
  final customColor = const Color(0xff000000);

  final red = Colors.redAccent;
}

class _TextStyles {
  final f10Regular = TextStyle(
    fontSize: 10,
    color: S.colors.black,
  );

  final black = TextStyle(
    color: S.colors.black,
  );

  final red = TextStyle(
    color: S.colors.red,
  );

  final title = TextStyle(
    color: S.colors.black,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
}

class _Shadows {
  final softShadow = [
    const BoxShadow(
      blurRadius: 20,
      offset: Offset(0, 2),
    )
  ];

  final hardShadow = [
    const BoxShadow(
      blurRadius: 20,
      offset: Offset(0, 2),
    )
  ];
}