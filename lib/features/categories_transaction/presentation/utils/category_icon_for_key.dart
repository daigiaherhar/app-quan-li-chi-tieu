import 'package:flutter/material.dart';

const Map<String, IconData> _categoryIconsByKey = <String, IconData>{
  'salary': Icons.payments_outlined,
  'bonus': Icons.celebration_outlined,
  'freelance': Icons.laptop_mac_outlined,
  'business': Icons.storefront_outlined,
  'investment': Icons.trending_up_rounded,
  'refund': Icons.replay_rounded,
  'gift': Icons.redeem_outlined,
  'other_income': Icons.savings_outlined,
  'food': Icons.restaurant_outlined,
  'transport': Icons.directions_car_outlined,
  'shopping': Icons.shopping_bag_outlined,
  'bills': Icons.receipt_long_outlined,
  'entertainment': Icons.movie_outlined,
  'health': Icons.favorite_outline_rounded,
  'education': Icons.school_outlined,
  'family': Icons.family_restroom_outlined,
  'other_expense': Icons.category_outlined,
};

IconData categoryIconForKey(String? key) {
  return _categoryIconsByKey[key] ?? Icons.category_outlined;
}
