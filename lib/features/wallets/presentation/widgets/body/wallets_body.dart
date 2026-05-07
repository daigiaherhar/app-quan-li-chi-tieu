part of '../../pages/wallets_page.dart';

class _WalletsBody extends StatelessWidget {
  const _WalletsBody({required this.walletsAsync});

  final AsyncValue<List<WalletEntity>> walletsAsync;

  @override
  Widget build(BuildContext context) {
    return walletsAsync.when(
      data: (List<WalletEntity> wallets) {
        if (wallets.isEmpty) {
          return Center(
            child: Text(
              'Chưa có ví nào',
              style: context.textStyles.bodyLarge.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          );
        }
        final double totalBalance = wallets.fold<double>(
          0,
          (double sum, WalletEntity wallet) =>
              sum + wallet.currentBalance.toDouble(),
        );
        return ListView.separated(
          padding: EdgeInsets.all(16.w(context)),
          itemCount: wallets.length + 2,
          separatorBuilder: (_, __) => SizedBox(height: 12.w(context)),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _WalletSummaryCard(totalBalance: totalBalance);
            }
            if (index == wallets.length + 1) {
              return SizedBox(height: 100.h(context));
            }
            final WalletEntity wallet = wallets[index - 1];
            return _WalletTile(wallet: wallet, isShowLottieRemove: index == 2);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => Center(
        child: Text(
          'Không tải được danh sách ví',
          style: context.textStyles.bodyLarge.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _WalletTile extends ConsumerWidget {
  const _WalletTile({required this.wallet, this.isShowLottieRemove = false});

  final WalletEntity wallet;
  final bool isShowLottieRemove;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Widget card = _buildCard(context);
    if (wallet.isDefault) {
      return card;
    }
    return Dismissible(
      key: ValueKey<String>('wallet_tile_${wallet.id}'),
      direction: DismissDirection.endToStart,
      background: _buildDismissBackground(context),
      confirmDismiss: (DismissDirection _) => _confirmAndDelete(context, ref),
      child: card,
    );
  }

  Future<bool> _confirmAndDelete(BuildContext context, WidgetRef ref) async {
    final bool confirmed = await _showConfirmDialog(context) ?? false;
    if (!confirmed || !context.mounted) {
      return false;
    }
    final Result<void> result = await ref
        .read(deleteWalletUseCaseProvider)
        .call(DeleteWalletParams(id: wallet.id));
    if (!context.mounted) {
      return result.isSuccess;
    }
    return result.when(
      onSuccess: (_) => true,
      onFailure: (String _, int __, dynamic ___) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Không xoá được ví. Vui lòng thử lại.',
              style: TextStyle(color: context.colors.onPrimary),
            ),
            backgroundColor: context.colors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return false;
      },
    );
  }

  Future<bool?> _showConfirmDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Xoá ví?'),
        content: Text(
          'Bạn có chắc muốn xoá "${wallet.name}"?\n'
          'Các giao dịch đã ghi vẫn được giữ lại.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: context.colors.error),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
  }

  Widget _buildDismissBackground(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 24.w(context)),
      decoration: BoxDecoration(
        color: context.colors.error,
        borderRadius: context.sizes.r14,
      ),
      child: Icon(
        Icons.delete_outline_rounded,
        color: context.colors.onPrimary,
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final bool isDefaultWallet = wallet.isDefault;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(14.w(context)),
          decoration: BoxDecoration(
            color: context.colors.cardSurface,
            borderRadius: context.sizes.r14,
            border: Border.all(
              color: context.colors.border.withValues(alpha: 0.28),
            ),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 44.w(context),
                height: 44.w(context),
                decoration: BoxDecoration(
                  color: context.colors.pastelIndigo.withValues(alpha: 0.45),
                  borderRadius: context.sizes.r12,
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: context.colors.pastelIndigoOn,
                ),
              ),
              context.gap.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            wallet.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textStyles.bodyLarge.copyWith(
                              color: context.colors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    context.gap.h4,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,

                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (isDefaultWallet) ...<Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w(context),
                              vertical: 2.w(context),
                            ),
                            decoration: BoxDecoration(
                              color: context.colors.pastelMint,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              'Mặc định',
                              style: context.textStyles.label.copyWith(
                                color: context.colors.pastelMintOn,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],

                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              formatAppCurrency(
                                wallet.currentBalance.toDouble(),
                              ),
                              style: context.textStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w800,
                                color: context.colors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (isShowLottieRemove)
          Positioned(
            bottom: -10.w(context),
            right: 0,
            child: SizedBox(
              width: 28.w(context),
              height: 28.w(context),
              child: Lottie.asset(Assets.assetLottie.touchLeft),
            ),
          ),
      ],
    );
  }
}
