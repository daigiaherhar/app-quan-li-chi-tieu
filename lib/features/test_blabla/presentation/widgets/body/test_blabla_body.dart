part of '../../pages/test_blabla_page.dart';

class _TestBlablaBody extends StatelessWidget {
  const _TestBlablaBody();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding: context.padding.all16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TestBlabla feature',
            style: context.textStyles.h2,
          ),
          context.gap.h8,
          Text(
            'Replace this placeholder UI with real content.',
            style: context.textStyles.bodyLarge,
          ),
        ],
      ),
    );
  }
}
