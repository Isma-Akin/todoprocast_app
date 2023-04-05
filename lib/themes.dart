import 'dart:ui';

import 'package:flutter/material.dart';

final appColorScheme = ColorScheme(
  primary: Color(0x1A2F64E1),
  secondary: Color(0x4C2F64E1),
  tertiary: Color(0x992F64E1),
  surface: Color(0xFF0D47A1),
  background: Color(0xFF0D47A1),
  error: Color(0xFF0D47A1),
  onPrimary: Color(0xFF0D47A1),
  onSecondary: Color(0xFF0D47A1),
  onSurface: Color(0xFF0D47A1),
  onBackground: Color(0xFF0D47A1),
  onError: Color(0xFF0D47A1),
  brightness: Brightness.light,
);

final appTheme = ThemeData(
  colorScheme: appColorScheme,
);