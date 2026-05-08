part of '../../pages/ocr_transaction_confirm_page.dart';

class _OcrConfirmSummaryHeader extends StatelessWidget {
  const _OcrConfirmSummaryHeader({
    required this.totalCount,
    required this.selectedCount,
  });

  final int totalCount;
  final int selectedCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w(context)),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: context.sizes.r16,
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 48.w(context),
            height: 48.w(context),
            decoration: BoxDecoration(
              color: context.colors.pastelIndigo,
              borderRadius: context.sizes.r16,
            ),
            child: Icon(
              Icons.document_scanner_rounded,
              color: context.colors.pastelIndigoOn,
              size: context.sizes.i24,
            ),
          ),
          context.gap.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '$selectedCount/$totalCount giao dịch',
                  style: context.textStyles.h3.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                context.gap.h4,
                Text(
                  'Kiểm tra lại trước khi lưu.',
                  style: context.textStyles.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
