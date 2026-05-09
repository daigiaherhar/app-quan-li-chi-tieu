import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_chi_tieu/features/ledger/presentation/providers/ledger_state.dart';
import 'package:quan_ly_chi_tieu/features/ledger/presentation/providers/ledger_notifier.dart';

NotifierProvider<LedgerNotifier, LedgerState> ledgerProvider =
    NotifierProvider<LedgerNotifier, LedgerState>(LedgerNotifier.new);
