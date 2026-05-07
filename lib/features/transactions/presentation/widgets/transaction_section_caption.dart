import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';

class TransactionSectionCaption extends StatelessWidget {
  const TransactionSectionCaption({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w(context)),
      child: Text(
        text.toUpperCase(),
        style: context.textStyles.label.copyWith(
          color: context.colors.textSecondary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          fontSize: 11.w(context),
        ),
      ),
    );
  }
}
