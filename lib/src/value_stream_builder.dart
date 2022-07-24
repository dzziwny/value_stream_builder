import 'package:flutter/material.dart';

import 'async_value_snapshot.dart';
import 'value_stream_builder_base.dart';

typedef AsyncValueWidgetBuilder<T> = Widget Function(
  BuildContext context,
  AsyncValueSnapshot<T> snapshot,
);

class ValueStreamBuilder<T>
    extends ValuesStreamBuilderBase<T, AsyncValueSnapshot<T>> {
  ValueStreamBuilder({
    super.key,
    required super.stream,
    required this.builder,
  }) : super(
          summary: AsyncValueSnapshot.withData(
            ConnectionState.active,
            stream.value,
          ),
        );

  final AsyncValueWidgetBuilder<T> builder;

  @override
  AsyncValueSnapshot<T> afterData(AsyncValueSnapshot<T> current, T data) =>
      AsyncValueSnapshot<T>.withData(ConnectionState.active, data);

  @override
  AsyncValueSnapshot<T> afterError(
      AsyncValueSnapshot<T> current, Object error, StackTrace stackTrace) {
    return AsyncValueSnapshot<T>.withError(
      ConnectionState.active,
      current.data,
      error,
      stackTrace,
    );
  }

  @override
  AsyncValueSnapshot<T> afterDone(AsyncValueSnapshot<T> current) =>
      current.inState(ConnectionState.done);

  @override
  AsyncValueSnapshot<T> afterDisconnected(AsyncValueSnapshot<T> current) =>
      current.inState(ConnectionState.none);

  @override
  Widget build(BuildContext context, AsyncValueSnapshot<T> currentSummary) =>
      builder(context, currentSummary);
}
