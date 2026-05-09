import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_chi_tieu/features/ledger/presentation/providers/ledger_state.dart';

class LedgerNotifier extends Notifier<LedgerState> {
  @override
  LedgerState build() {
    return LedgerState();
  }

  void selectTab(int index) {
    state = state.copyWith(chipIndex: index);
  }
}
