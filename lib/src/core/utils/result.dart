import 'dart:async';
import 'package:dio/dio.dart';

import 'package:unsplash_app/src/core/networking/exceptions/exceptions.dart';

/// This class will be used by class users in their methods.
///
/// A base class `Result` with two implementations — Success and Failure.
/// When you need to return a value from a function that
/// potentially can throw an Exception or may return an unexpected result,
/// you should use Result as a return value, like this:
/// ```dart
/// Result<int, String> divide(int a, int b) {
///  if (b == 0) {
///    return failure('Cannot divide by zero');
///  }
///  return success(a ~/ b);
/// }
/// ```
sealed class Result<S, F> {
  const Result._();

  bool get isLeft => this is Failure<S, F>;

  bool get isRight => this is Success<S, F>;

  /// `fold` takes two functions as parameters: one for handling a success value and one for handling an error value.
  /// It applies the appropriate function based on whether the Result represents a success or an error.
  /// ```dart
  /// final value = divide(2, 1).fold(
  ///  (r) => r, // returns the result if division succeeded
  ///  (e) => double.negativeInfinity, // returns negative inf if division failed
  ///);
  /// ```
  B fold<B>(B Function(S s) ifSuccess, B Function(F f) ifFailure);

  //   /// Get [Left] value, may throw an exception when the value is [Right]
  // L get left => this.fold<L>(
  //     (value) => value,
  //     (right) => throw Exception(
  //         'Illegal use. You should check isLeft before calling'));

  // /// Get [Right] value, may throw an exception when the value is [Left]
  // R get right => this.fold<R>(
  //     (left) => throw Exception(
  //         'Illegal use. You should check isRight before calling'),
  //     (value) => value);

  /// This function applies a transformation to the success value of the Result,
  /// and returns a new Result that contains the transformed value. If the Result
  /// represents an error, the transformation is not applied and
  /// the error is propagated to the new Result.
  Result<S2, F> map<S2>(S2 Function(S s) f) =>
      fold((S s) => success(f(s)), failure);

  /// Similar to map, but the transformation function returns a Result
  /// rather than a raw value. This is useful when the transformation itself can fail.
  Result<S2, F> flatMap<S2>(Result<S2, F> Function(S s) f) => fold(f, failure);

  /// An asynchronous version of flatMap.
  /// The transformation function is asynchronous (returns a Future<Result>) and
  /// so is asyncFlatMap itself.
  Future<Result<S2, F>> asyncFlatMap<S2>(
    Future<Result<S2, F>> Function(S s) f,
  ) =>
      fold(f, (error) => Future.value(failure(error)));

  /// Similar to map, but doesn't return a new Result. Instead, it simply applies
  /// a function for its side effects and returns nothing. If the Result is an error,
  /// the function is not applied.
  FutureOr<void> forEach<T>(FutureOr<T> Function(S) f) => fold(f, (_) {});

  /// Returns the success value if the Result represents a success, and defaultValue's
  /// result if it represents an error.
  S getOrElse(S Function() defaultValue) =>
      fold((s) => s, (_) => defaultValue());

  /// Returns the success value if the Result represents a success, and null
  /// if it represents an error.
  S? getOrNull() => fold((s) => s, (_) => null);

  /// Constructs a Result from a Future. If the Future completes successfully,
  /// the Result is a success with the value of the Future. If the Future fails,
  /// the Result is an error with the error of the Future.
  static Future<Result<T, Exception>> fromAsync<T>(
    Future<T> Function() func,
  ) async {
    try {
      final result = await func();
      return success(result);
    } on DioException catch (exception) {
      switch (exception.type) {
        case DioExceptionType.badResponse:
          final error = AppException.fromErrorResponse(exception.response!);
          return failure(error);
        case DioExceptionType.connectionError:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          return failure(
            const ClientException(
              message:
                  'Error establishing a connection to the server. Please try again',
            ),
          );
        case _:
          return failure(
            ClientException(
              message: exception.toString(),
            ),
          );
      }
    } on Exception catch (e) {
      return failure(ClientException(message: e.toString()));
    } on Error catch (e) {
      return failure(Exception('${e.runtimeType}: ${e.stackTrace}'));
    }
  }

  ///  Constructs a Result by running a function. If the function returns normally,
  /// the Result is a success with the return value of the function. If the function
  /// throws an exception, the Result is an error with the thrown exception.
  static Result<T, Exception> fromAction<T>(T Function() func) {
    try {
      final result = func();
      return success(result);
    } on Exception catch (e) {
      return failure(e);
      // ignore: avoid_catching_errors
    } on Error catch (e) {
      return failure(Exception('${e.runtimeType}: ${e.stackTrace}'));
    }
  }

  /// Constructs a Result from a value that may be null. If the value is non-null,
  /// the Result is a success with that value. If the value is null, the Result
  /// is an error.
  static Result<T, Exception> fromNullable<T>(
    T? value,
    Exception Function() onError,
  ) {
    if (value != null) {
      return success(value);
    } else {
      return failure(onError());
    }
  }

  /// Constructs a Result by testing a condition. If the condition is true,
  /// the Result is a success with a certain value. If the condition is false,
  /// the Result is an error with a certain error.
  static Result<T, Exception> fromPredicate<T>(
    bool condition,
    T Function() onSuccess,
    Exception Function() onError,
  ) =>
      condition ? success(onSuccess()) : failure(onError());
}

/// A container for Failure values
class Failure<S, F> extends Result<S, F> {
  const Failure._(this._f) : super._();

  final F _f;

  F get value => _f;

  @override
  B fold<B>(B Function(S s) ifSuccess, B Function(F f) ifFailure) =>
      ifFailure(_f);

  @override
  bool operator ==(Object other) => other is Failure && other._f == _f;

  @override
  int get hashCode => _f.hashCode;
}

/// A container for Success values
class Success<S, F> extends Result<S, F> {
  const Success._(this._s) : super._();

  final S _s;

  S get value => _s;

  @override
  B fold<B>(B Function(S s) ifSuccess, B Function(F f) ifFailure) =>
      ifSuccess(_s);

  @override
  bool operator ==(Object other) => other is Success && other._s == _s;

  @override
  int get hashCode => _s.hashCode;
}

Result<S, F> failure<S, F>(F f) => Failure._(f); // helper function
Result<S, F> success<S, F>(S s) => Success._(s); // helper function
