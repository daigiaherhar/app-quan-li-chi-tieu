# Riverpod Guide Cho App Quản Lý Chi Tiêu

App đang dùng `flutter_riverpod: ^3.3.1`. Tài liệu này là quy ước nội bộ để chọn đúng loại provider và viết UI/state theo Clean Architecture của repo.

## Tóm Tắt Nhanh

| Nhu cầu | Dùng |
| --- | --- |
| Inject dependency, repository, use case, service, config | `Provider<T>` |
| State UI có hành động thay đổi như tab, form, selected item, submit status | `NotifierProvider<NotifierT, StateT>` |
| Data realtime từ database/local source/API stream | `StreamProvider<T>` |
| Data async load 1 lần, không cần mutate thủ công | `FutureProvider<T>` |
| Widget chỉ cần đọc provider, không có controller/dispose | `ConsumerWidget` |
| Widget cần `TextEditingController`, `AnimationController`, `mounted`, `initState`, `dispose` | `ConsumerStatefulWidget` |
| Chỉ một phần nhỏ trong widget tree cần đọc provider | `Consumer` |
| Provider cần tham số như `transaction kind`, `id`, `filter` | `.family` |
| State chỉ sống theo màn rồi tự hủy | `.autoDispose` |

## Cách Chọn Provider

### 1. Dùng `Provider<T>` khi chỉ cần dependency

`Provider` phù hợp cho object không tự thay đổi state UI:

- database
- local data source
- repository
- use case
- service wrapper
- formatter/config

Ví dụ:

```dart
final Provider<WalletsRepository> walletsRepositoryProvider =
    Provider<WalletsRepository>((Ref ref) {
  return WalletsRepositoryImpl(ref.watch(walletsLocalDataSourceProvider));
});

final Provider<CreateWalletUseCase> createWalletUseCaseProvider =
    Provider<CreateWalletUseCase>((Ref ref) {
  return CreateWalletUseCase(ref.watch(walletsRepositoryProvider));
});
```

Không dùng `Provider<int>((_) => 0)` cho tab index nếu tab có thể đổi. Đó là state mutable, nên dùng `NotifierProvider`.

### 2. Dùng `NotifierProvider` khi state có hành động thay đổi

Dùng cho state kiểu:

- tab hiện tại trong root
- mở/đóng popup
- form thêm ví
- form giao dịch
- chọn category/wallet
- trạng thái submit/loading/error/success

Pattern nên dùng trong repo:

```text
lib/features/<feature>/presentation/providers/
  <feature>_state.dart
  <feature>_notifier.dart
  <feature>_providers.dart
```

Ví dụ state:

```dart
@immutable
class RootState {
  const RootState({
    required this.currentIndex,
    required this.isCenterMenuOpen,
  });

  factory RootState.initial() {
    return const RootState(
      currentIndex: 0,
      isCenterMenuOpen: false,
    );
  }

  final int currentIndex;
  final bool isCenterMenuOpen;

  RootState copyWith({
    int? currentIndex,
    bool? isCenterMenuOpen,
  }) {
    return RootState(
      currentIndex: currentIndex ?? this.currentIndex,
      isCenterMenuOpen: isCenterMenuOpen ?? this.isCenterMenuOpen,
    );
  }
}
```

Ví dụ notifier:

```dart
class RootNotifier extends Notifier<RootState> {
  @override
  RootState build() {
    return RootState.initial();
  }

  void selectTab(int index) {
    state = state.copyWith(
      currentIndex: index,
      isCenterMenuOpen: false,
    );
  }

  void toggleCenterMenu() {
    state = state.copyWith(isCenterMenuOpen: !state.isCenterMenuOpen);
  }
}
```

Ví dụ provider:

```dart
final NotifierProvider<RootNotifier, RootState> rootProvider =
    NotifierProvider<RootNotifier, RootState>(RootNotifier.new);
```

Trong widget:

```dart
class RootPage extends ConsumerWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RootState state = ref.watch(rootProvider);
    final RootNotifier notifier = ref.read(rootProvider.notifier);

    return RootDockTabBar(
      currentIndex: state.currentIndex,
      isCenterOpen: state.isCenterMenuOpen,
      onIndexChanged: notifier.selectTab,
      onCenterPressed: notifier.toggleCenterMenu,
    );
  }
}
```

### 3. Dùng `StreamProvider<T>` khi data tự cập nhật theo thời gian

Phù hợp với Drift/watch query, realtime database, hoặc bất kỳ `Stream<T>` nào.

Ví dụ ví đang hoạt động:

```dart
final StreamProvider<List<WalletEntity>> walletsProvider =
    StreamProvider<List<WalletEntity>>((Ref ref) {
  return ref.watch(watchActiveWalletsUseCaseProvider).call();
});
```

Trong UI:

```dart
class WalletsPage extends ConsumerWidget {
  const WalletsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<WalletEntity>> walletsAsync =
        ref.watch(walletsProvider);

    return walletsAsync.when(
      data: (List<WalletEntity> wallets) {
        return WalletList(wallets: wallets);
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
      error: (Object error, StackTrace stackTrace) {
        return const Center(child: Text('Không tải được danh sách ví'));
      },
    );
  }
}
```

Không convert stream sang local list bằng `setState`. Để `StreamProvider` giữ vai trò lắng nghe và rebuild UI.

### 4. Dùng `FutureProvider<T>` khi chỉ cần load async một lần

Phù hợp với:

- kiểm tra user đã nhập thông tin chưa
- load cấu hình ban đầu
- đọc dữ liệu async một lần

Ví dụ:

```dart
final FutureProvider<bool> hasUserInfoProvider =
    FutureProvider<bool>((Ref ref) async {
  return ref.watch(hasUserInfoUseCaseProvider).call();
});
```

Trong router hoặc UI có thể đọc `AsyncValue<bool>`.

Không dùng `FutureProvider` cho form submit có nhiều trạng thái `idle/submitting/success/failure`. Form submit nên dùng `NotifierProvider`.

## `Notifier<T>` Viết Như Thế Nào?

`Notifier<T>` là class quản lý state. `T` là kiểu state immutable.

Quy tắc:

- `build()` trả về state ban đầu.
- Dùng `state = state.copyWith(...)` để cập nhật.
- Không mutate trực tiếp field bên trong state.
- Method trong notifier là action của màn: `selectTab`, `submit`, `selectWallet`, `closeMenu`.
- Nếu gọi repository/use case, lấy qua `ref.read(...)`.
- Với luồng có lỗi, state nên có `errorMessage` hoặc `submitStatus`, không để UI tự bắt lỗi lung tung.

Ví dụ form submit:

```dart
enum AddWalletSubmitStatus { idle, submitting, success, failure }

@immutable
class AddWalletState {
  const AddWalletState({
    required this.name,
    required this.nameError,
    required this.submitStatus,
  });

  factory AddWalletState.initial() {
    return const AddWalletState(
      name: '',
      nameError: null,
      submitStatus: AddWalletSubmitStatus.idle,
    );
  }

  final String name;
  final String? nameError;
  final AddWalletSubmitStatus submitStatus;

  AddWalletState copyWith({
    String? name,
    String? nameError,
    bool clearNameError = false,
    AddWalletSubmitStatus? submitStatus,
  }) {
    return AddWalletState(
      name: name ?? this.name,
      nameError: clearNameError ? null : (nameError ?? this.nameError),
      submitStatus: submitStatus ?? this.submitStatus,
    );
  }
}
```

```dart
class AddWalletNotifier extends Notifier<AddWalletState> {
  @override
  AddWalletState build() {
    return AddWalletState.initial();
  }

  void nameChanged(String value) {
    state = state.copyWith(
      name: value,
      clearNameError: true,
    );
  }

  Future<void> submit() async {
    final String trimmedName = state.name.trim();
    if (trimmedName.isEmpty) {
      state = state.copyWith(nameError: 'Vui lòng nhập tên ví');
      return;
    }

    state = state.copyWith(submitStatus: AddWalletSubmitStatus.submitting);

    final Result<void> result = await ref.read(createWalletUseCaseProvider).call(
          CreateWalletParams(name: trimmedName),
        );

    state = result.when(
      onSuccess: (_) => state.copyWith(
        submitStatus: AddWalletSubmitStatus.success,
      ),
      onFailure: (_, __, ___) => state.copyWith(
        submitStatus: AddWalletSubmitStatus.failure,
      ),
    );
  }
}
```

Provider:

```dart
final NotifierProvider<AddWalletNotifier, AddWalletState> addWalletProvider =
    NotifierProvider<AddWalletNotifier, AddWalletState>(AddWalletNotifier.new);
```

## `ref.watch`, `ref.read`, `ref.listen`

### `ref.watch`

Dùng trong `build` để UI rebuild khi state đổi.

```dart
final RootState state = ref.watch(rootProvider);
```

### `ref.read`

Dùng trong callback/action để gọi method, không rebuild theo provider.

```dart
onPressed: () {
  ref.read(rootProvider.notifier).toggleCenterMenu();
}
```

Không dùng `ref.read(provider)` trong `build` để lấy state hiển thị lên UI, vì UI sẽ không tự rebuild.

### `ref.listen`

Dùng cho side effect:

- show snackbar
- navigate
- show dialog
- log analytics

Ví dụ:

```dart
ref.listen<AddWalletState>(addWalletProvider, (
  AddWalletState? previous,
  AddWalletState next,
) {
  if (next.submitStatus == AddWalletSubmitStatus.success) {
    Navigator.of(context).pop();
  }
});
```

Không gọi navigate/snackbar trực tiếp trong `build` dựa trên `if (state.isSuccess)` vì build có thể chạy nhiều lần.

## `ConsumerWidget`, `ConsumerStatefulWidget`, `Consumer`

### Dùng `ConsumerWidget` khi widget chỉ cần provider

```dart
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<double> totalAsync =
        ref.watch(dashboardWalletTotalProvider);

    return totalAsync.when(
      data: (double total) => Text('$total'),
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => const Text('Có lỗi xảy ra'),
    );
  }
}
```

### Dùng `ConsumerStatefulWidget` khi cần lifecycle local

Dùng khi cần:

- `TextEditingController`
- `FocusNode`
- `AnimationController`
- `PageController`
- `initState`
- `dispose`
- `mounted`
- `WidgetsBinding.instance.addPostFrameCallback`

Ví dụ:

```dart
class TransactionFormPage extends ConsumerStatefulWidget {
  const TransactionFormPage({super.key});

  @override
  ConsumerState<TransactionFormPage> createState() =>
      _TransactionFormPageState();
}

class _TransactionFormPageState extends ConsumerState<TransactionFormPage> {
  late final TextEditingController amountController;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TransactionState state = ref.watch(transactionProvider);

    return TextField(
      controller: amountController,
      decoration: InputDecoration(errorText: state.amountError),
    );
  }
}
```

### Dùng `Consumer` cho một phần nhỏ cần rebuild

Khi page lớn nhưng chỉ một nút/text cần provider:

```dart
class BigHeader extends StatelessWidget {
  const BigHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Text('Tổng quan'),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final AsyncValue<double> totalAsync =
                ref.watch(dashboardWalletTotalProvider);

            return totalAsync.when(
              data: (double total) => Text('$total'),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            );
          },
        ),
      ],
    );
  }
}
```

## `.family` Và `.autoDispose`

### `.family`

Dùng khi provider cần tham số.

Ví dụ transaction form có loại giao dịch:

```dart
final transactionProvider = NotifierProvider.autoDispose
    .family<TransactionNotifier, TransactionState, TransactionFlowKind>(
  TransactionNotifier.new,
);
```

Trong UI:

```dart
final TransactionState state = ref.watch(
  transactionProvider(TransactionFlowKind.expense),
);

ref.read(
  transactionProvider(TransactionFlowKind.expense).notifier,
).submit(
  amountText: amountController.text,
  noteText: noteController.text,
  walletId: walletId,
);
```

### `.autoDispose`

Dùng cho state chỉ sống theo màn:

- form thêm/sửa
- confirm OCR
- flow có param
- màn detail theo id

Không dùng `.autoDispose` cho state global cần giữ lâu như root tab nếu muốn quay lại app vẫn nhớ trạng thái.

## Nên Và Không Nên Trong Repo Này

### Nên

- Đặt state/notifier/provider trong `presentation/providers`.
- State là immutable class có `copyWith`.
- Notifier chỉ expose action rõ nghĩa, không expose setter linh tinh.
- Repository/use case trả `Result<T>` nếu là luồng có thể lỗi.
- UI dùng `AsyncValue.when` cho `StreamProvider`/`FutureProvider`.
- Dùng `ref.listen` cho snackbar/navigate.
- Dùng `ref.read(provider.notifier)` trong callback.

### Không nên

- Không dùng `setState` cho state flow chính của màn nếu đã có Riverpod.
- Không dùng `Provider` cho state cần thay đổi.
- Không mutate list/map bên trong state rồi giữ nguyên instance.
- Không gọi API/database trực tiếp trong widget.
- Không show snackbar/navigate trực tiếp trong `build`.
- Không đặt business rule nặng trong widget.
- Không tạo provider mới trong file widget nếu provider đó thuộc feature và cần tái sử dụng.

## Decision Tree

1. Đây có phải dependency không thay đổi không?
   - Có: dùng `Provider<T>`.
2. Data có phát sinh liên tục theo thời gian không?
   - Có: dùng `StreamProvider<T>`.
3. Data chỉ load async một lần và UI chỉ hiển thị kết quả?
   - Có: dùng `FutureProvider<T>`.
4. UI có action làm thay đổi state không?
   - Có: dùng `NotifierProvider<NotifierT, StateT>`.
5. Provider có cần tham số không?
   - Có: thêm `.family`.
6. State chỉ cần sống theo màn/flow không?
   - Có: thêm `.autoDispose`.
7. Widget có controller hoặc lifecycle local không?
   - Có: dùng `ConsumerStatefulWidget`.
   - Không: dùng `ConsumerWidget`.

## Ví Dụ Theo Feature

### Root tab

- `RootState`: `currentIndex`, `isCenterMenuOpen`
- `RootNotifier`: `selectTab`, `toggleCenterMenu`, `closeCenterMenu`
- `rootProvider`: `NotifierProvider`
- `RootPage`: `ConsumerStatefulWidget` nếu vẫn cần `GlobalKey`, post frame, hoặc lifecycle nhỏ

### Wallet list

- `walletsLocalDataSourceProvider`: `Provider`
- `walletsRepositoryProvider`: `Provider`
- `watchActiveWalletsUseCaseProvider`: `Provider`
- `walletsProvider`: `StreamProvider<List<WalletEntity>>`
- `WalletsPage`: `ConsumerWidget`

### Add wallet form

- `AddWalletState`: selected type, validation error, submit status
- `AddWalletNotifier`: validate, select type, submit
- `addWalletProvider`: `NotifierProvider`
- Bottom sheet: `ConsumerStatefulWidget` nếu có controller

### Transaction form

- `transactionProvider`: `NotifierProvider.autoDispose.family`
- Dùng `.family` vì form cần `TransactionFlowKind.income/expense`
- Dùng `.autoDispose` vì rời form thì state cũ nên được dọn

### OCR confirm

- `ocrTransactionConfirmProvider`: `NotifierProvider.autoDispose.family`
- Dùng `.family` vì provider nhận `OcrTransactionResult`
- Dùng `.autoDispose` vì đây là flow xác nhận theo lần scan
- Submit từng transaction qua use case, UI listen success/error để điều hướng/snackbar

## Mẫu File Chuẩn

```dart
// <feature>_state.dart
@immutable
class FeatureState {
  const FeatureState({
    required this.isLoading,
    required this.errorMessage,
  });

  factory FeatureState.initial() {
    return const FeatureState(
      isLoading: false,
      errorMessage: null,
    );
  }

  final bool isLoading;
  final String? errorMessage;

  FeatureState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return FeatureState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
```

```dart
// <feature>_notifier.dart
class FeatureNotifier extends Notifier<FeatureState> {
  @override
  FeatureState build() {
    return FeatureState.initial();
  }

  Future<void> submit() async {
    state = state.copyWith(
      isLoading: true,
      clearErrorMessage: true,
    );

    final Result<void> result = await ref.read(featureUseCaseProvider).call();

    state = result.when(
      onSuccess: (_) => state.copyWith(isLoading: false),
      onFailure: (_, __, ___) => state.copyWith(
        isLoading: false,
        errorMessage: 'Không thể thực hiện. Vui lòng thử lại.',
      ),
    );
  }
}
```

```dart
// <feature>_providers.dart
final NotifierProvider<FeatureNotifier, FeatureState> featureProvider =
    NotifierProvider<FeatureNotifier, FeatureState>(FeatureNotifier.new);
```
