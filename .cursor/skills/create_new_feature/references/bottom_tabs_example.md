# Bottom tabs: một feature per tab

## Nguyên tắc

- **Shell feature `root`**: chỉ router-level UI — `Scaffold`, `AppBar`/`BaseAppBar`, `BottomNavigationBar`, `FloatingActionButton`, `IndexedStack`.
- **Mỗi tab**: một thư mục `lib/features/<tab_feature_name>/` từ `scaffold_feature.cjs`, có `presentation/pages/<name>_page.dart` + `widgets/header` + `widgets/body` (`part`/`part of` theo skill).
- **Dữ liệu demo dùng chung**: `lib/core/demo/demo_data.dart` (tránh feature tab import lẫn nhau).

## Scaffold shell + các tab (index 0 → 3)

```bash
node .cursor/skills/create_new_feature/scripts/scaffold_feature.cjs root
node .cursor/skills/create_new_feature/scripts/scaffold_feature.cjs dashboard
node .cursor/skills/create_new_feature/scripts/scaffold_feature.cjs ledger
node .cursor/skills/create_new_feature/scripts/scaffold_feature.cjs reports
node .cursor/skills/create_new_feature/scripts/scaffold_feature.cjs profile
```

## Shell: `IndexedStack` + import page từng feature

```dart
import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:quan_ly_chi_tieu/features/ledger/presentation/pages/ledger_page.dart';
import 'package:quan_ly_chi_tieu/features/profile/presentation/pages/profile_page.dart';
import 'package:quan_ly_chi_tieu/features/reports/presentation/pages/reports_page.dart';

// Trong build:
body: IndexedStack(
  index: _tabIndex,
  children: const <Widget>[
    DashboardPage(),
    LedgerPage(),
    ReportsPage(),
    ProfilePage(),
  ],
),
```

Tab page **không** nhất thiết bọc thêm `Scaffold` nếu shell `root` đã có `Scaffold` + `AppBar` (tránh lồng scaffold); page tab trả về `ColoredBox` / `Column` + `Expanded` + nội dung.

## Vị trí file trong repo

- Shell: `lib/features/root/presentation/pages/root_page.dart`
- Demo data: `lib/core/demo/demo_data.dart`
