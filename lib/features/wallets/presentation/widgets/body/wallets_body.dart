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
          itemCount: wallets.length + 1,
          separatorBuilder: (_, __) => SizedBox(height: 12.w(context)),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _WalletSummaryCard(totalBalance: totalBalance);
            }
            final WalletEntity wallet = wallets[index - 1];
            return _WalletTile(wallet: wallet);
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

class _WalletTile extends StatelessWidget {
  const _WalletTile({required this.wallet});

  final WalletEntity wallet;

  @override
  Widget build(BuildContext context) {
    final bool isDefaultWallet = wallet.isDefault;
    return Container(
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
                    if (isDefaultWallet) ...<Widget>[
                      context.gap.w8,
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
                  ],
                ),
                context.gap.h4,
                Text(
                  wallet.type.toUpperCase(),
                  style: context.textStyles.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            formatAppCurrency(wallet.currentBalance.toDouble()),
            style: context.textStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w800,
              color: context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
