import 'package:flutter/material.dart';

@immutable
class TransactionWalletEntity {
  const TransactionWalletEntity({
    required this.id,
    required this.name,
    this.icon = Icons.account_balance_wallet_rounded,
  });

  final String id;
  final String name;
  final IconData icon;
}
