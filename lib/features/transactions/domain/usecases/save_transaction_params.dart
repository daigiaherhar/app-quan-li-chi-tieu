/// Input value object for saving a new transaction (income or expense).
///
/// Defined separately from [SaveTransactionUseCase] so other layers (notifiers,
/// repositories) can consume the same shape without depending on the use-case
/// class itself.
class SaveTransactionParams {
  const SaveTransactionParams({
    required this.amount,
    required this.type,
    required this.note,
    required this.happenedAt,
    required this.walletId,
    this.categoryId,
  });

  final int amount;
  final String type;
  final String note;
  final DateTime happenedAt;
  final String walletId;
  final String? categoryId;
}
