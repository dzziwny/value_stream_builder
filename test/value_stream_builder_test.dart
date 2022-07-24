import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

import 'package:value_stream_builder/value_stream_builder.dart';

void main() {
  testWidgets(
    'should work',
    (tester) async {
      final stream = BehaviorSubject.seeded('0');

      await tester.pumpWidget(
        MaterialApp(
          home: ValueStreamBuilder<String>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('error');
                }

                return Text(snapshot.data);
              }),
        ),
      );

      var finder = find.text('0');
      expect(finder, findsOneWidget);

      stream.add('1');
      await tester.pumpAndSettle();
      finder = find.text('1');
      expect(finder, findsOneWidget);

      stream.addError(Object());
      await tester.pumpAndSettle();
      finder = find.text('error');
      expect(finder, findsOneWidget);
    },
  );

  testWidgets(
    "should rebuild initial value once",
    (tester) async {
      final stream = BehaviorSubject.seeded('0');
      final completer = Completer();

      await tester.pumpWidget(
        MaterialApp(
          home: ValueStreamBuilder<String>(
              stream: stream,
              builder: (context, snapshot) {
                completer.complete();
                return Text(snapshot.data);
              }),
        ),
      );

      await tester.pump();
    },
  );
}
