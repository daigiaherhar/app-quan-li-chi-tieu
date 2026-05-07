import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quan_ly_chi_tieu/features/profile/presentation/providers/profile_providers.dart';
import 'package:quan_ly_chi_tieu/main.dart';

void main() {
  testWidgets('Root shell renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          hasUserInfoProvider.overrideWith((Ref ref) async => true),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Trang chủ'), findsWidgets);
  });
}
