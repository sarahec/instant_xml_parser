import 'package:runtime/runtime.dart';
import 'package:test/test.dart';

void main() {
  test('finds text in a single tag', () async {
    final events = generateEventStream(Stream.value('<a>Hello, world</a>'));
    final startTag = await events.start();
    final text = await events.textValue();
    expect(startTag, isNotNull);
    expect(text, equals('Hello, world'));
  });

  test('finds text in a sequential tags', () async {
    final events =
        generateEventStream(Stream.value('<a>One</a><a>Two</a><a>Three</a>'));
    final startTag = await events.start();
    final one = await events.textValue();
    final two = await events.textValue();
    final three = await events.textValue();
    expect(startTag, isNotNull);
    expect(one, equals('One'));
    expect(two, equals('Two'));
    expect(three, equals('Three'));
  });
}
