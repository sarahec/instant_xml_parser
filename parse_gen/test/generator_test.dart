import 'package:async/async.dart';
import 'package:test/test.dart';
import 'package:xml/xml_events.dart';

import 'src/example.dart';

void main() {
  StreamQueue<XmlEvent> _eventsFrom(String xml) => StreamQueue(Stream.value(xml)
      .toXmlEvents()
      .withParentEvents()
      .normalizeEvents()
      .flatten());

  group('bare tag', () {
    test('open-close', () async {
      var result = await emptyTag(_eventsFrom('<empty></empty>'));
      expect(result, isA<EmptyTag>());
    });

    test('self-closing', () async {
      var result = await emptyTag(_eventsFrom('<empty />'));
      expect(result, isA<EmptyTag>());
    });
  });

  group('implicit attributes', () {
    test('string from implicit attribute', () async {
      var result = await namedTag(_eventsFrom('<named name="foo" />'));
      expect(result, isA<NamedTag>());
      expect(result.name, equals('foo'));
    });

    test('values from implicit attribute', () async {
      var result = await attributesTag(_eventsFrom(
          '<attributesTest name="foo" count="999" temperature="22.1" active="1" />'));
      expect(result, isA<AttributesTag>());
      expect(result.name, equals('foo'), reason: 'extracted string');
      expect(result.count, equals(999), reason: 'extracted int');
      expect(result.temperature, equals(22.1), reason: 'extracted double');
      expect(result.active, isTrue, reason: 'extracted bool');
    });
  });
}
