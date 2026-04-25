---
name: create_new_feature
description: Tạo cấu trúc feature mới cho dự án Flutter Quan Ly Chi Tieu theo Clean Architecture, Riverpod, package imports, và UI pattern part/part of. Dùng khi cần scaffold nhanh một feature mới trong `lib/features/<feature_name>` với các thư mục data/domain/presentation, các file entity/repository/usecase/page/header/body, hoặc khi cần tạo bộ khung feature đúng chuẩn repo trước khi code logic thật.
---

# Create New Feature

Scaffold một feature mới cho repo này, rồi dùng skeleton đó làm nền để cài logic thật.

## Workflow

1. Đọc `references/project-rules.md`.
2. Chuẩn hóa `feature_name` về `snake_case`.
3. Chạy:
```bash
node .cursor/skills/create_new_feature/scripts/scaffold_feature.cjs <feature_name>
```
4. Thay placeholder UI và entity bằng nghiệp vụ thật.
5. Thêm provider, data source, repository implementation khi feature bắt đầu có state và dữ liệu.
6. Chạy `flutter analyze` sau khi hoàn thiện phần scaffold.
7. Nếu feature có test hoặc vừa thêm test mới, chạy `flutter test` cho phạm vi liên quan trước khi kết thúc.

## Ví dụ: bottom bar — mỗi tab là một feature (đúng output scaffold)

Với app có `BottomNavigationBar` / `IndexedStack`, **mỗi tab** nên là **một `feature_name` riêng** trong `lib/features/<feature_name>/` (đủ `data/`, `domain/`, `presentation/` + `part`/`part of`). Feature **shell** tên `root` chỉ giữ khung: AppBar, tab bar, FAB, và `IndexedStack` trỏ tới page của từng feature.

**Mapping gợi ý (repo demo):**

| `BottomNavigationBar` index | `feature_name` (scaffold) | Page import trong shell |
|----------------------------|---------------------------|---------------------------|
| 0 | `dashboard` | `package:quan_ly_chi_tieu/features/dashboard/presentation/pages/dashboard_page.dart` |
| 1 | `ledger` | `package:quan_ly_chi_tieu/features/ledger/presentation/pages/ledger_page.dart` |
| 2 | `reports` | `package:quan_ly_chi_tieu/features/reports/presentation/pages/reports_page.dart` |
| 3 | `profile` | `package:quan_ly_chi_tieu/features/profile/presentation/pages/profile_page.dart` |

**Lệnh scaffold shell + từng tab:**

```bash
node .cursor/skills/create_new_feature/scripts/scaffold_feature.cjs root
node .cursor/skills/create_new_feature/scripts/scaffold_feature.cjs dashboard
node .cursor/skills/create_new_feature/scripts/scaffold_feature.cjs ledger
node .cursor/skills/create_new_feature/scripts/scaffold_feature.cjs reports
node .cursor/skills/create_new_feature/scripts/scaffold_feature.cjs profile
```

Feature `root` (`lib/features/root/`) import các `*Page` ở bảng trên và đặt vào `IndexedStack(index: tabIndex, children: [...])`. Dữ liệu demo dùng chung đặt ở `lib/core/demo/demo_data.dart` để các feature tab không phụ thuộc lẫn nhau.

Chi tiết và snippet shell: xem [references/bottom_tabs_example.md](references/bottom_tabs_example.md).

## Output mặc định

- `data/datasources/`
- `data/models/`
- `data/repositories/`
- `domain/entities/<feature_name>_entity.dart`
- `domain/repositories/<feature_name>_repository.dart`
- `domain/usecases/get_<feature_name>_usecase.dart`
- `presentation/pages/<feature_name>_page.dart`
- `presentation/widgets/header/<feature_name>_header.dart`
- `presentation/widgets/body/<feature_name>_body.dart`
- `presentation/widgets/footer/`
- `presentation/providers/`

## Rules cần giữ

- Dùng `package:quan_ly_chi_tieu/...` imports.
- Với app bar, dùng `package:quan_ly_chi_tieu/shared/widgets/appbar/base_app_bar.dart`.
- Dùng `Result<T>` ở use case và repository contract.
- Dùng `context.colors`, `context.textStyles`, `context.padding`, `context.gap`.
- Với UI, page là file chính và widget con dùng `part of`.
- Không đổi sang `setState` nếu state bắt đầu phức tạp; ưu tiên Riverpod.
- Trước khi chốt feature, phải ưu tiên chạy `flutter analyze`, rồi chạy `flutter test` nếu có test liên quan.

## Resources

- Đọc `references/project-rules.md` khi cần naming, layout, và boundaries của feature.
- Bottom bar + nhiều tab: `references/bottom_tabs_example.md`.
- Dùng `scripts/scaffold_feature.cjs` để tạo skeleton ổn định thay vì viết tay.
- Dùng `assets/feature-checklist.txt` như checklist cuối sau khi scaffold.
