import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

class ContextMenuTheme extends ThemeExtension<ContextMenuTheme> {
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final Color shortcutColor;

  final double iconSize;
  final double fontSize;

  final double disabledOpacity;

  final ShapeBorder? shape;

  ContextMenuTheme({
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    Color? shortcutColor,
    double? fontSize,
    double? iconSize,
    double? disabledOpacity,
    ShapeBorder? shape,
  })  : backgroundColor = backgroundColor ?? const Color(0xFF212121),
        textColor = textColor ?? Colors.white.withOpacity(0.7),
        iconColor = iconColor ?? Colors.white.withOpacity(0.7),
        shortcutColor = shortcutColor ?? Colors.white.withOpacity(0.5),
        fontSize = fontSize ?? 16,
        iconSize = iconSize ?? 20,
        disabledOpacity = disabledOpacity ?? 0.1,
        shape = shape ??
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4));

  Color get disabledTextColor => textColor.withOpacity(disabledOpacity);
  Color get disabledIconColor => iconColor.withOpacity(disabledOpacity);
  Color get disabledShortcutColor => shortcutColor.withOpacity(disabledOpacity);

  @override
  ThemeExtension<ContextMenuTheme> copyWith({
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    Color? shortcutColor,
    double? fontSize,
    double? iconSize,
    double? disabledOpacity,
    ShapeBorder? shape,
  }) {
    return ContextMenuTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      iconColor: iconColor ?? this.iconColor,
      shortcutColor: shortcutColor ?? this.shortcutColor,
      fontSize: fontSize ?? this.fontSize,
      iconSize: iconSize ?? this.iconSize,
      disabledOpacity: disabledOpacity ?? this.disabledOpacity,
      shape: shape ?? this.shape,
    );
  }

  @override
  ThemeExtension<ContextMenuTheme> lerp(
    ThemeExtension<ContextMenuTheme>? other,
    double t,
  ) {
    if (other == null) {
      return this;
    }

    if (other is! ContextMenuTheme) {
      return this;
    }

    return ContextMenuTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      textColor: Color.lerp(textColor, other.textColor, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      shortcutColor: Color.lerp(shortcutColor, other.shortcutColor, t),
      fontSize: lerpDouble(fontSize, other.fontSize, t),
      iconSize: lerpDouble(iconSize, other.iconSize, t),
      disabledOpacity: lerpDouble(disabledOpacity, other.disabledOpacity, t),
      shape: ShapeBorder.lerp(shape, other.shape, t),
    );
  }
}
