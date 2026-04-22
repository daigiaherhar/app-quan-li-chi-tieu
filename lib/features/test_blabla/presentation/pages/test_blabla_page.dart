import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/shared/widgets/widgets.dart';

part '../widgets/header/test_blabla_header.dart';
part '../widgets/body/test_blabla_body.dart';

class TestBlablaPage extends ConsumerWidget {
  const TestBlablaPage({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: const _TestBlablaHeader(
        title: 'TestBlabla',
      ),
      body: const _TestBlablaBody(),
    );
  }
}
