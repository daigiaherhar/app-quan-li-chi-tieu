# App Quan Ly Chi Tieu Feature Rules

## Architecture

- Mỗi feature nằm dưới `lib/features/<feature_name>/`.
- Tách theo `data`, `domain`, `presentation`.
- Chỉ thêm `data/` khi feature có source dữ liệu rõ ràng hoặc mock có cấu trúc.

## Domain

- `entities/` chứa model nghiệp vụ thuần.
- `repositories/` chứa contract.
- `usecases/` trả về `Future<Result<T>>`.
- Ưu tiên field `final`.

## Presentation

- `pages/` là entry widget của feature.
- `widgets/` chia thành `header`, `body`, `footer`.
- `providers/` dành cho Riverpod providers/notifiers.
- Với page dùng `part`/`part of`, page file giữ imports và khai báo `part`.

## UI conventions

- Dùng `package:quan_ly_chi_tieu/...` imports.
- App bar dùng `package:quan_ly_chi_tieu/shared/widgets/appbar/base_app_bar.dart`.
- Dùng `context.colors`, `context.textStyles`, `context.padding`, `context.gap`, `context.screenWidth`, `context.screenHeight`.
- Tránh hard-code spacing và text style nếu helper có sẵn.
- Giữ file ngắn, dễ đọc; nếu section dài thì tách widget.

## Verification

- Sau thay đổi code có ý nghĩa, chạy `flutter analyze`.
- Nếu có test liên quan đến feature đang sửa, chạy `flutter test` cho phần bị ảnh hưởng.
- Nếu không thể chạy verify, phải nêu rõ nguyên nhân và phần nào chưa được xác nhận.

## Naming

- Tên thư mục và file dùng `snake_case`.
- Class dùng `PascalCase`.
- Page class theo mẫu `<FeatureName>Page`.
- Use case class theo mẫu `Get<FeatureName>UseCase` hoặc động từ phù hợp.

## Cấu trúc nên tạo tối thiểu

- `domain/entities/<feature_name>_entity.dart`
- `domain/repositories/<feature_name>_repository.dart`
- `domain/usecases/get_<feature_name>_usecase.dart`
- `presentation/pages/<feature_name>_page.dart`
- `presentation/widgets/header/<feature_name>_header.dart`
- `presentation/widgets/body/<feature_name>_body.dart`
- `presentation/widgets/footer/`
- `presentation/providers/`
