import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';
import 'package:quan_ly_chi_tieu/core/utils/vnd_amount_input_format.dart';
import 'package:quan_ly_chi_tieu/generated/assets.dart';

class TransactionAmountHero extends StatefulWidget {
  const TransactionAmountHero({
    super.key,
    required this.amountController,
    required this.amountFocus,
    required this.amountError,
    required this.formatDisplay,
    required this.accentColor,
    required this.heroMiddleColor,
    required this.heroGradientAccent,
    required this.heroHint,
    this.sLottie,
  });

  final TextEditingController amountController;
  final FocusNode amountFocus;
  final String? amountError;
  final String Function(String rawDigits) formatDisplay;
  final Color accentColor;
  final Color heroMiddleColor;
  final Color heroGradientAccent;
  final String heroHint;
  final String? sLottie;

  @override
  State<TransactionAmountHero> createState() => _TransactionAmountHeroState();
}

class _TransactionAmountHeroState extends State<TransactionAmountHero> {
  static const FontWeight _amountWeight = FontWeight.w800;

  @override
  void initState() {
    super.initState();
    widget.amountController.addListener(_onAmountTextChanged);
  }

  @override
  void didUpdateWidget(TransactionAmountHero oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.amountController != widget.amountController) {
      oldWidget.amountController.removeListener(_onAmountTextChanged);
      widget.amountController.addListener(_onAmountTextChanged);
    }
  }

  @override
  void dispose() {
    widget.amountController.removeListener(_onAmountTextChanged);
    super.dispose();
  }

  void _onAmountTextChanged() {
    setState(() {});
  }

  double _suffixWidth(TextStyle unitStyle) {
    final TextPainter painter = TextPainter(
      text: TextSpan(text: kAppCurrency.displayLabel, style: unitStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return painter.width;
  }

  TextStyle _amountStyleForMeasure(BuildContext context, double fontSize) {
    return context.textStyles.h1.copyWith(
      fontSize: fontSize,
      fontWeight: _amountWeight,
      color: widget.accentColor,
      height: 1.1,
    );
  }

  /// Largest font in [minPx, maxPx] whose single-line intrinsic width fits [maxWidth].
  double _fitAmountFontSize({
    required BuildContext context,
    required String text,
    required double maxWidth,
    required double minPx,
    required double maxPx,
  }) {
    final String sample = text.isEmpty ? '0' : text;
    if (maxWidth <= 0) return minPx;
    double best = minPx;
    double low = minPx;
    double high = maxPx;
    while (low <= high) {
      final double mid = (low + high) / 2;
      final TextPainter painter = TextPainter(
        text: TextSpan(
          text: sample,
          style: _amountStyleForMeasure(context, mid),
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();
      if (painter.width <= maxWidth) {
        best = mid;
        low = mid + 0.5;
      } else {
        high = mid - 0.5;
      }
    }
    return best;
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = widget.amountError != null;
    return Container(
      padding: EdgeInsets.fromLTRB(
        22.w(context),
        24.w(context),
        22.w(context),
        20.w(context),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            context.colors.white,
            widget.heroMiddleColor,
            widget.heroGradientAccent,
          ],
        ),
        borderRadius: context.sizes.r16,
        border: Border.all(
          color: hasError
              ? context.colors.error.withValues(alpha: 0.45)
              : widget.accentColor.withValues(alpha: 0.22),
          width: hasError ? 1.5 : 1,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: widget.accentColor.withValues(alpha: 0.14),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              SvgPicture.asset(
                Assets.assetIcons.vnd,
                colorFilter: ColorFilter.mode(
                  widget.accentColor,
                  BlendMode.srcIn,
                ),
                height: context.sizes.i24,
                width: context.sizes.i24,
                // size: context.sizes.i24,
              ),

              context.gap.w12,
              Expanded(
                child: Text(
                  widget.heroHint,
                  style: context.textStyles.bodyMedium.copyWith(
                    color: context.colors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ),
              if (widget.sLottie != null && widget.sLottie!.isNotEmpty) ...[
                context.gap.w12,
                SizedBox(
                  width: 44.w(context),
                  height: 44.w(context),
                  child: Lottie.asset(widget.sLottie!),
                ),
              ],
            ],
          ),
          context.gap.h16,
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final TextStyle unitStyle = context.textStyles.h3.copyWith(
                color: widget.accentColor.withValues(alpha: 0.82),
                fontWeight: FontWeight.w700,
                fontSize: 20.w(context),
                height: 1.0,
              );
              final double suffixW = _suffixWidth(unitStyle);
              final double suffixGap = 8.w(context);
              final double reserved = 10.w(context) + suffixW + suffixGap;
              double lineBasis = constraints.maxWidth;
              if (!lineBasis.isFinite || lineBasis <= 0) {
                lineBasis =
                    MediaQuery.sizeOf(context).width -
                    40.w(context) -
                    44.w(context);
              }
              final double lineMaxWidth = (lineBasis - reserved).clamp(
                0.0,
                double.infinity,
              );
              final double maxFont = 38.w(context);
              final double minFont = 18.w(context);
              final double amountFontSize = _fitAmountFontSize(
                context: context,
                text: widget.amountController.text,
                maxWidth: lineMaxWidth,
                minPx: minFont,
                maxPx: maxFont,
              );
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: widget.amountController,
                      focusNode: widget.amountFocus,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.start,
                      inputFormatters: <TextInputFormatter>[
                        GroupedThousandsInputFormatter(
                          formatDisplay: widget.formatDisplay,
                        ),
                      ],
                      style: context.textStyles.h1.copyWith(
                        color: widget.accentColor,
                        fontWeight: _amountWeight,
                        fontSize: amountFontSize,
                        height: 1.1,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: '0',
                        hintStyle: context.textStyles.h1.copyWith(
                          color: context.colors.textSecondary.withValues(
                            alpha: 0.28,
                          ),
                          fontWeight: _amountWeight,
                          fontSize: amountFontSize,
                          height: 1.1,
                        ),
                        errorStyle: const TextStyle(height: 0, fontSize: 0),
                      ),
                    ),
                  ),
                  SizedBox(width: suffixGap),
                  Text(kAppCurrency.displayLabel, style: unitStyle),
                ],
              );
            },
          ),
          if (widget.amountError != null) ...<Widget>[
            context.gap.h8,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.error_outline_rounded,
                  size: 18.w(context),
                  color: context.colors.error,
                ),
                context.gap.w8,
                Expanded(
                  child: Text(
                    widget.amountError!,
                    style: context.textStyles.bodySmall.copyWith(
                      color: context.colors.error,
                      fontSize: 13.w(context),
                      height: 1.25,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
