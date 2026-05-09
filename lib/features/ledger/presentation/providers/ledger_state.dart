import 'package:freezed_annotation/freezed_annotation.dart';

part 'ledger_state.freezed.dart';

enum TabTransaction {
  all('Tất cả'),
  income("Thu nhập"),
  expense("Chi trả");

  const TabTransaction(this.label);

  final String label;
}

@freezed
abstract class LedgerState with _$LedgerState {
  factory LedgerState({
    @Default(0) int chipIndex,
    @Default(TabTransaction.all) TabTransaction tabTransaction,
  }) = _LedgerState;
}
