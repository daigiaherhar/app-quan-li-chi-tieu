---
description: 
alwaysApply: true
---

---
description: 
alwaysApply: true
---

---
description: 
alwaysApply: true
---

# Codex Project Rules

Repo này là ứng dụng Flutter theo hướng Clean Architecture và ưu tiên code dễ mở rộng theo feature.

## Mục tiêu khi Codex làm việc trong repo này

- Giữ đúng cấu trúc `lib/core/` và `lib/features/`.
- Ưu tiên thay đổi nhỏ, rõ ràng, và bám conventions hiện có.
- Không thêm thư viện mới nếu chưa thật cần thiết.
- Khi sửa UI, tận dụng toàn bộ hệ `context.*` đã có thay vì hard-code spacing, color, text style; ưu tiên tái sử dụng widget trong `lib/shared/widgets/` trước khi viết component mới (xem mục Quy tắc `lib/shared/widgets`).

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

## Quy tắc `lib/shared/widgets`

**Trước khi làm widget UI mới:** luôn **rà soát `lib/shared/widgets/`** (và thư mục con: `buttons/`, `dialogs/`, …). Nếu đã có widget đủ gần nhu cầu → **dùng lại** hoặc **mở rộng** widget đó (thêm tham số tùy chọn, `enum` style…) thay vì tạo bản sao trong feature.

### Nên dùng / mở rộng `shared` khi

- Cùng một **pattern UI** (nút, bottom sheet, tile, chip…) xuất hiện hoặc **sắp xuất hiện** ở **từ hai chỗ** trở lên.
- Widget **không** phụ thuộc domain của một feature (không import `features/foo/domain`).
- Muốn **thống nhất** hành vi & giao diện (touch target, animation, theme) trên nhiều màn.

### Giữ widget trong feature (không thêm vào `shared`) khi

- Chỉ phục vụ **một màn / một luồng**, layout gắn chặt business hoặc mock cụ thể của feature đó.
- Chưa có lần dùng thứ hai thật sự—**đừng** tạo file shared “để sau có thể cần”.

### Khi buộc phải thêm widget mới vào `shared`

- Đặt đúng **thư mục con** theo vai trò (ví dụ `buttons/`, `dialogs/`), file `snake_case`, **một widget chính rõ ràng** mỗi file khi phù hợp.
- Dùng **`package:quan_ly_chi_tieu/shared/widgets/...`** (hoặc path tương ứng project) và hệ `context.colors` / `context.textStyles` / `context.gap` như phần Quy tắc UI.
- Trong PR/mô tả thay đổi: nêu **đã tìm trong `shared` chưa** và vì sao cần widget mới.

## Quy tắc `lib/core/utils`

**Mục tiêu:** chỉ đặt helper **thực sự dùng chung** nhiều nơi trong app; tránh tạo file util “dự phòng” hoặc abstract sớm.

### Nên đưa vào `core/utils` khi

- Logic là **hàm thuần** (pure): không cần `BuildContext`, không đọc widget/Cubit/Riverpod; có thể test dễ, không phụ thuộc một feature cụ thể.
- Đã **lặp lại** cùng một quy ước ở **hai feature trở lên** (hoặc một feature nhưng **rõ ràng** sẽ dùng ở màn khác ngay sau đó—ví dụ format tiền, ngày tháng, locale Việt).
- Là **quy ước app-wide**: format số tiền VND, nhãn tháng/năm, chuỗi theo giờ trong ngày, parser/formatter dùng chung—tương tự như `app_locale_format.dart`, `size_utils.dart`.

### Giữ trong feature (không tạo util core) khi

- Chỉ một màn hoặc một luồng dùng, và **chưa** có nhu cầu tái sử dụng thật.
- Logic gắn với **một entity/state** của feature đó (mapping UI cho riêng màn đó, sorting theo rule business chỉ của feature).
- Chỉ để “cho đẹp” hoặc “để sau có thể dùng”—**Rule of three**: ưu tiên chờ bản sao thứ hai thật sự trước khi extract.
- Cần **nhiều tham số ngữ cảnh** từ feature (repository, provider…)—đặt trong `domain`/`data`/`presentation` của feature, không nhét vào `core/utils`.

### Cách đặt file trong `core/utils`

- Một nhóm chủ đề rõ (locale + tiền tệ → một file; kích thước responsive → file riêng đã có).
- Tên file `snake_case`, API **tiếng Anh**, chuỗi hiển thị có thể tiếng Việt nếu đó là sản phẩm của util (ví dụ lời chào).
- Import: `package:quan_ly_chi_tieu/core/utils/<file>.dart`.

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
