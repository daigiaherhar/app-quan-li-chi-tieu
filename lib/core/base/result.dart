sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
}

final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;

  @override
  String toString() => 'Success($data)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Success<T> && data == other.data;

  @override
  int get hashCode => data.hashCode;
}

final class Failure<T> extends Result<T> {
  const Failure(this.message, {this.statusCode = 0, this.errorResponse});

  final String message;
  final int statusCode;
  final dynamic errorResponse;

  @override
  String toString() => 'Failure($message, statusCode: $statusCode)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> &&
          message == other.message &&
          statusCode == other.statusCode &&
          errorResponse == other.errorResponse;

  @override
  int get hashCode => Object.hash(message, statusCode, errorResponse);
}

extension ResultHandler<T> on Result<T> {
  Result<T> onSuccess(final void Function(T data) callback) {
    if (this is Success<T>) {
      callback((this as Success<T>).data);
    }
    return this;
  }

  Result<T> onFailure(
    final void Function(String message, int statusCode) callback,
  ) {
    if (this is Failure<T>) {
      callback((this as Failure<T>).message, (this as Failure<T>).statusCode);
    }
    return this;
  }

  R when<R>({
    required R Function(T data) onSuccess,
    required R Function(String message, int statusCode, dynamic errorResponse)
        onFailure,
  }) {
    return switch (this) {
      Success<T>(data: final data) => onSuccess(data),
      Failure<T>(
        message: final message,
        statusCode: final statusCode,
        errorResponse: final errorResponse,
      ) =>
        onFailure(message, statusCode, errorResponse),
    };
  }
}
