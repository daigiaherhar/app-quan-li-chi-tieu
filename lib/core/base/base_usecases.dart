import 'package:quan_ly_chi_tieu/core/base/result.dart';

abstract class BaseUseCase<Params, T> {
  Future<Result<T>> call(Params params);
}

abstract class BaseUseCaseNoParams<T> {
  Future<Result<T>> call();
}
