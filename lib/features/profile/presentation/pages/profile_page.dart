import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';

part '../widgets/header/profile_header.dart';
part '../widgets/body/profile_body.dart';

/// Tab 3 — Cá nhân (feature `profile` + UI demo).
class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.dashboardBackground,
      child: const SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _ProfileHeader(),
            Expanded(
              child: _ProfileBody(),
            ),
          ],
        ),
      ),
    );
  }
}
