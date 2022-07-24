import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

abstract class ValuesStreamBuilderBase<T, S> extends StatefulWidget {
  const ValuesStreamBuilderBase({
    Key? key,
    required this.stream,
    required this.summary,
  }) : super(key: key);

  final ValueStream<T> stream;
  final S summary;

  S afterData(S current, T data);
  S afterError(S current, Object error, StackTrace stackTrace) => current;
  S afterDone(S current) => current;
  S afterDisconnected(S current) => current;

  Widget build(BuildContext context, S currentSummary);

  @override
  State<ValuesStreamBuilderBase<T, S>> createState() =>
      _ValuesStreamBuilderBaseState<T, S>();
}

class _ValuesStreamBuilderBaseState<T, S>
    extends State<ValuesStreamBuilderBase<T, S>> {
  StreamSubscription<T>? _subscription;
  late S _summary = widget.summary;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void didUpdateWidget(ValuesStreamBuilderBase<T, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stream != widget.stream) {
      if (_subscription != null) {
        _unsubscribe();
        _summary = widget.afterDisconnected(_summary);
      }
      _subscribe();
    }
  }

  @override
  Widget build(BuildContext context) => widget.build(context, _summary);

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    _subscription = widget.stream.skip(1).listen((T data) {
      setState(() {
        _summary = widget.afterData(_summary, data);
      });
    }, onError: (Object error, StackTrace stackTrace) {
      setState(() {
        _summary = widget.afterError(_summary, error, stackTrace);
      });
    }, onDone: () {
      setState(() {
        _summary = widget.afterDone(_summary);
      });
    });
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }
}
