/// Input value object for creating a wallet.
///
/// Defined separately from [CreateWalletUseCase] so other layers (notifiers,
/// repositories) can consume the same shape without depending on the use-case
/// class itself.
class CreateWalletParams {
  const CreateWalletParams({
    required this.name,
    required this.type,
    this.openingBalance = 0,
  });

  final String name;
  final String type;
  final int openingBalance;
}
