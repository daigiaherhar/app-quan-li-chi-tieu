import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/router/app_route_paths.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';
import 'package:quan_ly_chi_tieu/features/ocr_transactions/domain/entities/ocr_transaction_result.dart';
import 'package:quan_ly_chi_tieu/features/ocr_transactions/domain/usecases/scan_receipt_image_params.dart';
import 'package:quan_ly_chi_tieu/features/ocr_transactions/presentation/providers/ocr_transaction_providers.dart';

Future<void> showOcrTransactionScanner(BuildContext context) async {
  if (kIsWeb) {
    _showSnackBar(context, 'OCR ảnh hiện chỉ hỗ trợ Android/iOS.');
    return;
  }

  final ImageSource? source = await showModalBottomSheet<ImageSource>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.22),
    builder: (BuildContext sheetContext) {
      return const _ImageSourceSheet();
    },
  );
  if (source == null || !context.mounted) {
    return;
  }

  final ImagePicker picker = ImagePicker();
  if (source == ImageSource.camera && !picker.supportsImageSource(source)) {
    _showSnackBar(context, 'Thiết bị này chưa hỗ trợ chụp ảnh trực tiếp.');
    return;
  }

  final XFile? image = await picker.pickImage(
    source: source,
    imageQuality: 88,
    maxWidth: 1800,
  );
  if (image == null || !context.mounted) {
    return;
  }

  final Uint8List imageBytes;
  try {
    imageBytes = await image.readAsBytes();
  } catch (_) {
    if (context.mounted) {
      _showSnackBar(context, 'Không đọc được ảnh. Vui lòng thử lại.');
    }
    return;
  }

  if (!context.mounted) {
    return;
  }

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.22),
    builder: (BuildContext sheetContext) {
      return _OcrTransactionResultSheet(
        imagePath: image.path,
        imageBytes: imageBytes,
        imageMimeType: image.mimeType ?? _guessImageMimeType(image.path),
      );
    },
  );
}

void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.maybeOf(context)
    ?..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

String _guessImageMimeType(String path) {
  final String lowerPath = path.toLowerCase();
  if (lowerPath.endsWith('.png')) {
    return 'image/png';
  }
  if (lowerPath.endsWith('.webp')) {
    return 'image/webp';
  }
  if (lowerPath.endsWith('.heic')) {
    return 'image/heic';
  }
  if (lowerPath.endsWith('.heif')) {
    return 'image/heif';
  }
  return 'image/jpeg';
}

class _ImageSourceSheet extends StatelessWidget {
  const _ImageSourceSheet();

  @override
  Widget build(BuildContext context) {
    final double bottomSafe = MediaQuery.paddingOf(context).bottom;
    return SafeArea(
      top: false,
      child: Container(
        margin: EdgeInsets.all(12.w(context)),
        padding: EdgeInsets.fromLTRB(
          16.w(context),
          14.w(context),
          16.w(context),
          16.w(context) + bottomSafe,
        ),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(24.w(context)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
              blurRadius: 26,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Quét hóa đơn',
              style: context.textStyles.h3.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            context.gap.h4,
            Text(
              'Chọn ảnh rõ chữ để tạo giao dịch tự động.',
              style: context.textStyles.bodySmall.copyWith(
                color: context.colors.textSecondary,
                height: 1.35,
              ),
            ),
            context.gap.h16,
            Row(
              children: <Widget>[
                Expanded(
                  child: _ImageSourceButton(
                    icon: Icons.photo_camera_rounded,
                    title: 'Chụp ảnh',
                    subtitle: 'Camera',
                    onTap: () => Navigator.pop(context, ImageSource.camera),
                  ),
                ),
                context.gap.w12,
                Expanded(
                  child: _ImageSourceButton(
                    icon: Icons.photo_library_rounded,
                    title: 'Thư viện',
                    subtitle: 'Ảnh có sẵn',
                    onTap: () => Navigator.pop(context, ImageSource.gallery),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageSourceButton extends StatelessWidget {
  const _ImageSourceButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.dashboardBackground,
      borderRadius: context.sizes.r16,
      child: InkWell(
        onTap: onTap,
        borderRadius: context.sizes.r16,
        child: Padding(
          padding: EdgeInsets.all(14.w(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 42.w(context),
                height: 42.w(context),
                decoration: BoxDecoration(
                  color: context.colors.pastelIndigo,
                  borderRadius: context.sizes.r14,
                ),
                child: Icon(
                  icon,
                  color: context.colors.pastelIndigoOn,
                  size: context.sizes.i24,
                ),
              ),
              context.gap.h12,
              Text(
                title,
                style: context.textStyles.bodyMedium.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              context.gap.h2,
              Text(
                subtitle,
                style: context.textStyles.bodySmall.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OcrTransactionResultSheet extends ConsumerStatefulWidget {
  const _OcrTransactionResultSheet({
    required this.imagePath,
    required this.imageBytes,
    required this.imageMimeType,
  });

  final String imagePath;
  final Uint8List imageBytes;
  final String imageMimeType;

  @override
  ConsumerState<_OcrTransactionResultSheet> createState() =>
      _OcrTransactionResultSheetState();
}

class _OcrTransactionResultSheetState
    extends ConsumerState<_OcrTransactionResultSheet> {
  late final Future<Result<OcrTransactionResult>> _scanFuture;
  bool _didOpenConfirmPage = false;

  @override
  void initState() {
    super.initState();
    _scanFuture = ref
        .read(scanReceiptImageUseCaseProvider)
        .call(
          ScanReceiptImageParams(
            imagePath: widget.imagePath,
            imageBytes: widget.imageBytes,
            imageMimeType: widget.imageMimeType,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final double bottomSafe = MediaQuery.paddingOf(context).bottom;
    final double bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(top: 12.w(context)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24.w(context)),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 32,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.only(bottom: bottomInset),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                20.w(context),
                16.w(context),
                20.w(context),
                18.w(context) + bottomSafe,
              ),
              child: FutureBuilder<Result<OcrTransactionResult>>(
                future: _scanFuture,
                builder:
                    (
                      BuildContext context,
                      AsyncSnapshot<Result<OcrTransactionResult>> snapshot,
                    ) {
                      final Result<OcrTransactionResult>? result =
                          snapshot.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const _SheetHandle(),
                          context.gap.h16,
                          _OcrSheetHeader(isLoading: !snapshot.hasData),
                          context.gap.h20,
                          if (snapshot.connectionState != ConnectionState.done)
                            const _OcrLoadingView()
                          else if (result == null)
                            const _OcrErrorView(
                              message:
                                  'Không có kết quả OCR. Vui lòng thử lại.',
                            )
                          else
                            result.when(
                              onSuccess: (OcrTransactionResult data) {
                                _openConfirmPage(data);
                                return const _OcrLoadingView(
                                  message: 'Đang mở màn xác nhận...',
                                );
                              },
                              onFailure: (String message, int _, dynamic __) =>
                                  _OcrErrorView(message: message),
                            ),
                        ],
                      );
                    },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openConfirmPage(OcrTransactionResult result) {
    if (_didOpenConfirmPage) {
      return;
    }
    _didOpenConfirmPage = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final GoRouter router = GoRouter.of(context);
      Navigator.of(context).pop();
      router.push(AppRoutePaths.ocrTransactionConfirm, extra: result);
    });
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 72.w(context),
        height: 5.w(context),
        decoration: BoxDecoration(
          color: context.colors.textSecondary.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

class _OcrSheetHeader extends StatelessWidget {
  const _OcrSheetHeader({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
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
                isLoading ? 'Đang đọc hóa đơn' : 'Đã đọc xong',
                style: context.textStyles.h3.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (isLoading) ...<Widget>[
                context.gap.h4,
                Text(
                  'Đang phân tích ảnh bằng Firebase AI.',
                  style: context.textStyles.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _OcrLoadingView extends StatelessWidget {
  const _OcrLoadingView({this.message = 'Đang nhận diện giao dịch...'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w(context)),
      decoration: BoxDecoration(
        color: context.colors.dashboardBackground,
        borderRadius: context.sizes.r16,
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 24.w(context),
            height: 24.w(context),
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: context.colors.pastelIndigoOn,
            ),
          ),
          context.gap.w12,
          Expanded(
            child: Text(
              message,
              style: context.textStyles.bodyMedium.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OcrErrorView extends StatelessWidget {
  const _OcrErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w(context)),
      decoration: BoxDecoration(
        color: context.colors.expenseSurface,
        borderRadius: context.sizes.r16,
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.error_outline_rounded, color: context.colors.expense),
          context.gap.w12,
          Expanded(
            child: Text(
              message,
              style: context.textStyles.bodyMedium.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
