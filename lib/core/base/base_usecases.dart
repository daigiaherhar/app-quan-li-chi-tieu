import 'package:quan_ly_chi_tieu/core/base/result.dart';

abstract class BaseUseCase<Params, T> {
  Future<Result<T>> call(Params params);
}

abstract class BaseUseCaseNoParams<T> {
  Future<Result<T>> call();
}

abstract class BaseStreamUseCase<Params, T> {
  Stream<T> call(Params params);
}

abstract class BaseStreamUseCaseNoParams<T> {
  Stream<T> call();
}
