# Dự án Quan Ly Chi Tieu - Coding Standards

## Kiến trúc hệ thống
- **Kiến trúc:** Clean Architecture.
- **Layers:**
    - `data/`: Repositories implementation, Data sources, Models (DTOs).
    - `domain/`: Entities (Sử dụng `@immutable` và `copyWith`), Repositories interfaces, UseCases.
    - `presentation/`: Riverpod Providers, Widgets, Pages.

## Quản lý trạng thái
- Sử dụng **Riverpod** (Functional/Generator style).
- Không sử dụng `setState` trong các logic phức tạp.

## Quy tắc Code UI
- **Khoảng cách & Size:** Luôn sử dụng `context.padding`, `context.gap` và `context.sizes`.
- **Màu sắc & Style:** Luôn sử dụng `context.colors` và `context.textStyles`.
- **Responsive:** Sử dụng `context.screenWidth`, `context.screenHeight`.
- **Cấu trúc Page:** Luôn phân tách UI thành các phương thức private (Ví dụ: `_buildAppBar`, `_buildBody`, `_buildContent`) để tăng tính dễ đọc.
- **Tách Widget:** Nếu một phương thức `_build` vượt quá 50 dòng code hoặc mang tính chất tái sử dụng cao, bắt buộc phải tách ra thành một file riêng trong thư mục `presentation/widgets/`.
- **Tổ chức Widgets:** Thư mục `widgets/` phải được chia nhỏ thành các thư mục con theo vị trí hoặc chức năng:
    - `header/`: Chứa các widget phần đầu trang (AppBar custom, Search bar...).
    - `body/`: Chứa các widget phần nội dung chính (Cards, Lists, Forms...).
    - `footer/`: Chứa các widget phần cuối trang (Buttons group, Bottom bar...).
- **Giới hạn File:** Ưu tiên giữ các file Widget/Page dưới 200 dòng code.

## Quy trình làm việc (Workflows)
- **Xác nhận thay đổi:** Mọi thao tác sửa đổi hoặc tạo mới mã nguồn phải được giải thích rõ ràng về mục đích và nội dung trước khi thực thi. Người dùng sẽ xem xét và xác nhận (hoặc hủy) thông qua giao diện của công cụ.

## Quy tắc Linter & Coding Style
- **Const:** Luôn ưu tiên sử dụng `const` cho constructors và literals (`prefer_const_constructors`).
- **Imports:** Luôn sử dụng `package:` imports thay vì relative imports (`always_use_package_imports`).
- **Formatting:** Luôn sử dụng dấu phẩy cuối (`trailing comma`) cho các danh sách tham số hoặc widget dài để linter tự động format đẹp hơn.
- **Naming:** Tuân thủ `snake_case` cho file, `camelCase` cho biến/hàm, và `PascalCase` cho class.
- **Sắp xếp:** Đặt constructors lên đầu class (`sort_constructors_first`).
- **Final:** Sử dụng `final` cho các biến không thay đổi giá trị (`prefer_final_fields`).

## Xử lý dữ liệu & Lỗi
- Các UseCase phải trả về `Result<T>` (Success/Failure) thay vì throw Exception.
- Sử dụng cơ chế `switch (result) { Success() => ..., Failure() => ... }` để xử lý kết quả.

## Thư mục & File
- Đặt tên file theo kiểu `snake_case`.
- Các feature mới phải nằm trong thư mục `lib/features/`.
