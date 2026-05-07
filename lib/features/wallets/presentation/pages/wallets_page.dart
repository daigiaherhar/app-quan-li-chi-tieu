import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/utils/app_locale_format.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';
import 'package:quan_ly_chi_tieu/features/wallets/domain/entities/wallet_entity.dart';
import 'package:quan_ly_chi_tieu/features/wallets/domain/usecases/delete_wallet_params.dart';
import 'package:quan_ly_chi_tieu/features/wallets/presentation/providers/wallets_providers.dart';
import 'package:quan_ly_chi_tieu/features/wallets/presentation/widgets/dialogs/add_wallet_bottom_sheet.dart';
import 'package:quan_ly_chi_tieu/generated/assets.dart';
import 'package:quan_ly_chi_tieu/shared/widgets/widgets.dart';

part '../widgets/header/wallets_header.dart';
part '../widgets/body/wallets_body.dart';

class WalletsPage extends ConsumerWidget {
  const WalletsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<WalletEntity>> walletsAsync = ref.watch(
      walletsProvider,
    );

    return Scaffold(
      backgroundColor: context.colors.dashboardBackground,
      appBar: BaseAppBar(
        title: 'Quản lý ví',
        backgroundColor: context.colors.dashboardBackground,
        titleColor: context.colors.textPrimary,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddWalletBottomSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Thêm ví'),
      ),

      body: _WalletsBody(walletsAsync: walletsAsync),
    );
  }
}
