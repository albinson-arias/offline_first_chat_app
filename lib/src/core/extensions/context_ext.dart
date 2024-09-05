import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  Size get size => MediaQuery.of(this).size;

  double get height => size.height;

  double get width => size.width;

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;
}
