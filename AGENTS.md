# Codex Project Rules

Repo này là ứng dụng Flutter theo hướng Clean Architecture và ưu tiên code dễ mở rộng theo feature.

## Mục tiêu khi Codex làm việc trong repo này

- Giữ đúng cấu trúc `lib/core/` và `lib/features/`.
- Ưu tiên thay đổi nhỏ, rõ ràng, và bám conventions hiện có.
- Không thêm thư viện mới nếu chưa thật cần thiết.
- Khi sửa UI, tận dụng toàn bộ hệ `context.*` đã có thay vì hard-code spacing, color, text style.

## Quy tắc kiến trúc

- Tạo feature mới bên trong `lib/features/<feature_name>/`.
- Tách theo lớp `data/`, `domain/`, `presentation/` khi feature đã có logic thực tế.
- Trong `domain/`, giữ entity, repository contract, và use case.
- Trong `presentation/`, ưu tiên Riverpod và widget tách nhỏ theo vai trò.
- Dùng `Result<T>` cho luồng trả kết quả của use case và repository thay vì ném lỗi trực tiếp.

## Quy tắc UI

- Dùng `context.padding`, `context.gap`, `context.colors`, `context.textStyles`, `context.screenWidth`, `context.screenHeight` khi có thể.
- Không hard-code spacing lặp lại nếu hệ `AppPadding`, `AppGap`, `AppSizes` đã đáp ứng.
- Giữ page/widget dễ đọc; nếu một khối `_build...` dài hoặc có thể tái sử dụng, tách ra file riêng.
- Với widget theo trang, ưu tiên chia trong `presentation/widgets/header`, `body`, `footer`.

## Quy tắc code style

- Dùng `package:` import.
- Ưu tiên `const`, `final`, trailing commas, và tên file `snake_case`.
- Không dùng `print` trong code production.
- Giữ constructor ở đầu class nếu phù hợp với linter hiện tại.

## Quy tắc làm việc

- Trước khi sửa nhiều file hoặc đổi cấu trúc, giải thích ngắn mục tiêu thay đổi.
- Khi chưa chắc cách tổ chức, ưu tiên khớp `GEMINI.md` và patterns đang có trong `lib/`.
- Sau mỗi thay đổi code Dart/Flutter có ý nghĩa, luôn chạy `flutter analyze` trước khi chốt.
- Nếu thay đổi có test liên quan hoặc có thể thêm test hợp lý, chạy `flutter test` cho phạm vi bị ảnh hưởng trước khi chốt.
- Nếu không chạy được `flutter analyze` hoặc `flutter test`, phải nói rõ lý do trong phần kết quả.
