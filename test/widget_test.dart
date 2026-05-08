import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quan_ly_chi_tieu/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:quan_ly_chi_tieu/features/profile/presentation/providers/profile_providers.dart';
import 'package:quan_ly_chi_tieu/main.dart';

void main() {
  testWidgets('Root shell renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          hasUserInfoProvider.overrideWith((Ref ref) async => true),
          dashboardWalletTotalProvider.overrideWith(
            (Ref ref) => Stream<double>.value(0),
          ),
          dashboardTransactionsProvider.overrideWith(
            (Ref ref) => Stream.value(const []),
          ),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(find.text('Trang chủ'), findsWidgets);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
  });
}
