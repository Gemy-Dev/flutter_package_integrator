abstract class Either<L, R> {
  factory Either.success(R? value) = Success;
  factory Either.failure(L value) = Failure;

  T? match<T>({
    required T? Function(R? value) onRight,
    required T Function(L value) onLeft,
  });
}

class Success<L, R> implements Either<L, R> {
  final R? value;

  Success(this.value);

  @override
  T? match<T>({
    required T? Function(R? value) onRight,
    required T Function(L value) onLeft,
  }) {
    return onRight(value);
  }
}

class Failure<L, R> implements Either<L, R> {
  final L value;

  Failure(this.value);
  @override
  T? match<T>({
    required T? Function(R? value) onRight,
    required T Function(L value) onLeft,
  }) {
    return onLeft(value);
  }
}
