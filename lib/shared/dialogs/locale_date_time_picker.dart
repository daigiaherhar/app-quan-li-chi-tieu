import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';

Future<DateTime?> _showCupertinoDateTimeSheet(
  BuildContext context,
  DateTime initial,
) {
  DateTime selected = initial;
  return showCupertinoModalPopup<DateTime>(
    context: context,
    builder: (BuildContext popContext) {
      final double bottomInset = MediaQuery.paddingOf(popContext).bottom;
      return Container(
        height: 312.w(popContext) + bottomInset,
        decoration: BoxDecoration(
          color: popContext.colors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.w(popContext)),
          ),
          border: Border.all(
            color: popContext.colors.border.withValues(alpha: 0.35),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 10.w(popContext)),
            Container(
              width: 42.w(popContext),
              height: 4.w(popContext),
              decoration: BoxDecoration(
                color: popContext.colors.divider,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w(popContext),
                vertical: 4.w(popContext),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    padding: EdgeInsets.symmetric(horizontal: 12.w(popContext)),
                    onPressed: () => Navigator.pop(popContext),
                    child: Text(
                      'Hủy',
                      style: popContext.textStyles.bodyMedium.copyWith(
                        color: popContext.colors.textSecondary,
                      ),
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.symmetric(horizontal: 12.w(popContext)),
                    onPressed: () => Navigator.pop(popContext, selected),
                    child: Text(
                      'Xong',
                      style: popContext.textStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: popContext.colors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: popContext.colors.divider),
            Expanded(
              child: Localizations.override(
                context: popContext,
                locale: const Locale('vi', 'VN'),
                child: CupertinoDatePicker(
                  initialDateTime: initial,
                  minimumDate: DateTime(2000),
                  maximumDate: DateTime(2100, 12, 31, 23, 59),
                  mode: CupertinoDatePickerMode.dateAndTime,
                  use24hFormat: true,
                  onDateTimeChanged: (DateTime value) => selected = value,
                ),
              ),
            ),
            SizedBox(height: bottomInset),
          ],
        ),
      );
    },
  );
}

Future<DateTime?> _showMaterialDatePicker(
  BuildContext context,
  DateTime initial,
) {
  return showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    locale: const Locale('vi', 'VN'),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: Theme.of(context).copyWith(
          datePickerTheme: DatePickerThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.w(context)),
            ),
            backgroundColor: context.colors.surface,
          ),
        ),
        child: child ?? const SizedBox.shrink(),
      );
    },
  );
}

Future<TimeOfDay?> _showMaterialTimePicker(
  BuildContext context,
  TimeOfDay initialTime,
) {
  return showTimePicker(
    context: context,
    initialTime: initialTime,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: Theme.of(context).copyWith(
          timePickerTheme: TimePickerThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.w(context)),
            ),
            backgroundColor: context.colors.surface,
          ),
        ),
        child: child ?? const SizedBox.shrink(),
      );
    },
  );
}

/// Full date+time picker: Cupertino sheet on iOS; Material date/time with `vi_VN`.
Future<DateTime?> pickDateTimeWithViLocale(
  BuildContext context,
  DateTime initial,
) async {
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
    return _showCupertinoDateTimeSheet(context, initial);
  }
  final DateTime? date = await _showMaterialDatePicker(context, initial);
  if (!context.mounted || date == null) {
    return null;
  }
  final TimeOfDay initialTime = TimeOfDay.fromDateTime(initial);
  final TimeOfDay? time = await _showMaterialTimePicker(context, initialTime);
  if (!context.mounted || time == null) {
    return null;
  }
  return DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );
}
