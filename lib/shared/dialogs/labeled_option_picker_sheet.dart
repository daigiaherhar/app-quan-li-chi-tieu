import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';

/// Modal sheet: labeled options; returns category, label, and icon. Scrolls when list is long.
Future<T?> showLabeledOptionPickerSheet<T>({
  required BuildContext context,
  required String title,
  required List<T> items,
  required String Function(T) labelOf,
  required IconData Function(T) iconOf,
  required T selected,
  required Color accentColor,
  required Color selectedSurfaceColor,
}) {
  return showModalBottomSheet<T>(
    context: context,
    showDragHandle: false,
    isScrollControlled: true,
    barrierColor: Colors.black.withValues(alpha: 0.22),
    backgroundColor: Colors.transparent,
    builder: (BuildContext sheetContext) {
      final double screenH = MediaQuery.sizeOf(sheetContext).height;
      final double listMaxHeight = screenH * 0.52;
      final double bottomSafe = MediaQuery.paddingOf(sheetContext).bottom;
      return Padding(
        padding: EdgeInsets.only(top: 12.w(sheetContext)),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: sheetContext.colors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24.w(sheetContext)),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 32,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24.w(sheetContext)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      0,
                      14.w(sheetContext),
                      0,
                      10.w(sheetContext),
                    ),
                    child: Center(
                      child: Container(
                        width: math.min(
                          80.w(sheetContext),
                          MediaQuery.sizeOf(sheetContext).width * 0.22,
                        ),
                        height: 6.w(sheetContext),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              sheetContext.colors.textSecondary
                                  .withValues(alpha: 0.14),
                              sheetContext.colors.textSecondary
                                  .withValues(alpha: 0.26),
                            ],
                          ),
                          border: Border.all(
                            color: sheetContext.colors.white
                                .withValues(alpha: 0.65),
                            width: 0.8,
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: accentColor.withValues(alpha: 0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      24.w(sheetContext),
                      4.w(sheetContext),
                      24.w(sheetContext),
                      8.w(sheetContext),
                    ),
                    child: Text(
                      title,
                      style: sheetContext.textStyles.h3.copyWith(
                        color: sheetContext.colors.textPrimary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 24.w(sheetContext),
                    endIndent: 24.w(sheetContext),
                    color: sheetContext.colors.divider.withValues(alpha: 0.55),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: listMaxHeight),
                    child: _LabeledOptionPickerList<T>(
                      sheetContext: sheetContext,
                      items: items,
                      selected: selected,
                      labelOf: labelOf,
                      iconOf: iconOf,
                      accentColor: accentColor,
                      selectedSurfaceColor: selectedSurfaceColor,
                      bottomPadding: 16.w(sheetContext) + bottomSafe,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _LabeledOptionPickerList<T> extends StatefulWidget {
  const _LabeledOptionPickerList({
    required this.sheetContext,
    required this.items,
    required this.selected,
    required this.labelOf,
    required this.iconOf,
    required this.accentColor,
    required this.selectedSurfaceColor,
    required this.bottomPadding,
  });

  final BuildContext sheetContext;
  final List<T> items;
  final T selected;
  final String Function(T) labelOf;
  final IconData Function(T) iconOf;
  final Color accentColor;
  final Color selectedSurfaceColor;
  final double bottomPadding;

  @override
  State<_LabeledOptionPickerList<T>> createState() =>
      _LabeledOptionPickerListState<T>();
}

class _LabeledOptionPickerListState<T> extends State<_LabeledOptionPickerList<T>> {
  final GlobalKey _selectedRowKey = GlobalKey();
  int _scrollAttempts = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollSelectedIntoView());
  }

  void _scrollSelectedIntoView() {
    if (!mounted) return;
    final BuildContext? ctx = _selectedRowKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        alignment: 0.12,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    if (_scrollAttempts < 5) {
      _scrollAttempts++;
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _scrollSelectedIntoView());
    }
  }

  @override
  Widget build(BuildContext context) {
    final BuildContext sheetContext = widget.sheetContext;
    return ListView.separated(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        20.w(sheetContext),
        14.w(sheetContext),
        20.w(sheetContext),
        widget.bottomPadding,
      ),
      itemCount: widget.items.length,
      separatorBuilder: (_, __) => SizedBox(height: 10.w(sheetContext)),
      itemBuilder: (_, int index) {
        final T item = widget.items[index];
        final bool isSelected = item == widget.selected;
        final IconData itemIcon = widget.iconOf(item);
        return Material(
          key: isSelected ? _selectedRowKey : ValueKey<int>(index),
          color: Colors.transparent,
          borderRadius: sheetContext.sizes.r16,
          child: InkWell(
            onTap: () => Navigator.pop(
              sheetContext,
              item,
            ),
            borderRadius: sheetContext.sizes.r16,
            splashColor: widget.accentColor.withValues(alpha: 0.12),
            highlightColor: widget.accentColor.withValues(alpha: 0.06),
            child: Ink(
              decoration: BoxDecoration(
                color: isSelected
                    ? widget.selectedSurfaceColor
                    : sheetContext.colors.cardSurface,
                borderRadius: sheetContext.sizes.r16,
                border: Border.all(
                  width: isSelected ? 1.5 : 1,
                  color: isSelected
                      ? widget.accentColor.withValues(alpha: 0.42)
                      : sheetContext.colors.border.withValues(alpha: 0.22),
                ),
                boxShadow: <BoxShadow>[
                  if (isSelected)
                    BoxShadow(
                      color: widget.accentColor.withValues(alpha: 0.14),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    )
                  else
                    BoxShadow(
                      color: sheetContext.colors.cardShadow,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 18.w(sheetContext),
                  vertical: 15.w(sheetContext),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 46.w(sheetContext),
                      height: 46.w(sheetContext),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? widget.accentColor.withValues(alpha: 0.2)
                            : sheetContext.colors.dashboardBackground,
                        borderRadius: sheetContext.sizes.r12,
                        border: Border.all(
                          color: isSelected
                              ? widget.accentColor.withValues(alpha: 0.35)
                              : sheetContext.colors.border
                                  .withValues(alpha: 0.2),
                        ),
                      ),
                      child: Icon(
                        itemIcon,
                        color: isSelected
                            ? widget.accentColor
                            : sheetContext.colors.textSecondary,
                        size: 24.w(sheetContext),
                      ),
                    ),
                    SizedBox(width: 14.w(sheetContext)),
                    Expanded(
                      child: Text(
                        widget.labelOf(item),
                        style: sheetContext.textStyles.bodyLarge.copyWith(
                          color: sheetContext.colors.textPrimary,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          height: 1.25,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Container(
                        padding: EdgeInsets.all(2.w(sheetContext)),
                        decoration: BoxDecoration(
                          color: widget.accentColor.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: widget.accentColor,
                          size: math.max(18.0, sheetContext.sizes.i20),
                        ),
                      )
                    else
                      Icon(
                        Icons.chevron_right_rounded,
                        color: sheetContext.colors.textSecondary
                            .withValues(alpha: 0.35),
                        size: sheetContext.sizes.i24,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
