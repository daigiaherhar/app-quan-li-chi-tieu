import '../models/error_model.dart';

abstract class BaseState {
  const BaseState({this.isLoading = false, this.errorModel});

  final bool isLoading;
  final ErrorModel? errorModel;

  BaseState copyWith({final bool? isLoading, final ErrorModel? errorModel});
}
