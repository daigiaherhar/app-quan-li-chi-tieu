import 'package:flutter/material.dart';

/// Common transaction category entity used by presentation and picker UI.
class TransactionCategoryEntity {
  const TransactionCategoryEntity({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final IconData icon;
}
