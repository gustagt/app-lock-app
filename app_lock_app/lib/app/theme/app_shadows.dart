import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static List<BoxShadow> small(Color primary) => [
        BoxShadow(
          color: primary.withValues(alpha: 0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> medium(Color primary) => [
        BoxShadow(
          color: primary.withValues(alpha: 0.08),
          blurRadius: 24,
          spreadRadius: 0,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> large(Color primary) => [
        BoxShadow(
          color: primary.withValues(alpha: 0.12),
          blurRadius: 40,
          offset: const Offset(0, 16),
        ),
      ];
}
