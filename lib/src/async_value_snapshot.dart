import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class AsyncValueSnapshot<T> {
  const AsyncValueSnapshot._(
    this.connectionState,
    this.data,
    this.error,
    this.stackTrace,
  );

  const AsyncValueSnapshot.withData(ConnectionState state, T data)
      : this._(state, data, null, null);

  const AsyncValueSnapshot.withError(
    ConnectionState state,
    T data,
    Object error, [
    StackTrace stackTrace = StackTrace.empty,
  ]) : this._(state, data, error, stackTrace);

  final ConnectionState connectionState;

  final T data;

  final Object? error;

  final StackTrace? stackTrace;

  AsyncValueSnapshot<T> inState(ConnectionState state) =>
      AsyncValueSnapshot<T>._(state, data, error, stackTrace);

  bool get hasError => error != null;

  @override
  String toString() =>
      '${objectRuntimeType(this, 'AsyncValueSnapshot')}($connectionState, $data, $error, $stackTrace)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AsyncSnapshot<T> &&
        other.connectionState == connectionState &&
        other.data == data &&
        other.error == error &&
        other.stackTrace == stackTrace;
  }

  @override
  int get hashCode => Object.hash(connectionState, data, error);
}
