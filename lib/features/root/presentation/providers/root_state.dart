import 'package:flutter/foundation.dart';

@immutable
class RootState {
  const RootState({required this.currentIndex, required this.isCenterMenuOpen});

  factory RootState.initial() {
    return const RootState(currentIndex: 0, isCenterMenuOpen: false);
  }

  final int currentIndex;
  final bool isCenterMenuOpen;

  RootState copyWith({int? currentIndex, bool? isCenterMenuOpen}) {
    return RootState(
      currentIndex: currentIndex ?? this.currentIndex,
      isCenterMenuOpen: isCenterMenuOpen ?? this.isCenterMenuOpen,
    );
  }
}
