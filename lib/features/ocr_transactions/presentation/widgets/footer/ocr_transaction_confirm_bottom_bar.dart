part of '../../pages/ocr_transaction_confirm_page.dart';

class _OcrConfirmBottomBar extends StatelessWidget {
  const _OcrConfirmBottomBar({
    required this.selectedCount,
    required this.isSaving,
    required this.canSave,
    required this.onSave,
  });

  final int selectedCount;
  final bool isSaving;
  final bool canSave;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16.w(context),
          12.w(context),
          16.w(context),
          12.w(context),
        ),
        child: SizedBox(
          height: 52.w(context),
          child: FilledButton.icon(
            onPressed: canSave && !isSaving ? onSave : null,
            icon: isSaving
                ? SizedBox(
                    width: 18.w(context),
                    height: 18.w(context),
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check_rounded),
            label: Text(
              isSaving ? 'Đang lưu...' : 'Lưu $selectedCount giao dịch',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            style: FilledButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: context.colors.onPrimary,
              textStyle: context.textStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w800,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.w(context)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
