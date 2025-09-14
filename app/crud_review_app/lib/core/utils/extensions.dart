import 'package:flutter/material.dart';

extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }
}

extension DoubleExtensions on double {
  String formatRating() {
    return toStringAsFixed(1);
  }
}

extension IntExtensions on int {
  String formatDistance() {
    if (this < 1000) {
      return '${this}m';
    } else {
      final km = (this / 1000).toStringAsFixed(1);
      return '${km}km';
    }
  }

  String formatReviewCount() {
    if (this < 1000) {
      return '$this';
    } else if (this < 1000000) {
      final k = (this / 1000).toStringAsFixed(1);
      return '${k}K';
    } else {
      final m = (this / 1000000).toStringAsFixed(1);
      return '${m}M';
    }
  }
}

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}


