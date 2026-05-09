import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_chi_tieu/features/root/presentation/providers/root_state.dart';

class RootNotifier extends Notifier<RootState> {
  @override
  RootState build() {
    return RootState.initial();
  }

  void selectTab(int index) {
    state = state.copyWith(currentIndex: index, isCenterMenuOpen: false);
  }

  void toggleCenterMenu() {
    state = state.copyWith(isCenterMenuOpen: !state.isCenterMenuOpen);
  }

  void closeCenterMenu() {
    if (!state.isCenterMenuOpen) {
      return;
    }
    state = state.copyWith(isCenterMenuOpen: false);
  }
}
