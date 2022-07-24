# value_stream_builder

Don't wait for first value from `BehaviorSubject` in `StreamBuilder` - just use `ValueStreamBuilder` and get non-null `snapshot.data`.

## Usage

```dart
ValueStreamBuilder<String>(
    stream: BehaviorSubject.seeded('Foo'),
    builder: (context, snapshot) => Text(snapshot.data);
),
```
