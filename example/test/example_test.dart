import 'package:async/async.dart';
import 'package:example/example.dart';
import 'package:runtime/runtime.dart';
import 'package:test/test.dart';
import 'package:xml/xml_events.dart';

void main() {
  StreamQueue<XmlEvent> _eventsFrom(String xml) => StreamQueue(Stream.value(xml)
      .toXmlEvents()
      .withParentEvents()
      .normalizeEvents()
      .flatten());

  group('self-contained tag', () {
    test('core attributes', () async {
      var result = await attributesTag(_eventsFrom(
          '<attributesTest name="foo" count="999" temperature="22.1" active="1" />'));
      expect(result, isA<AttributesTag>());
      expect(result.name, equals('foo'), reason: 'extracted string');
      expect(result.count, equals(999), reason: 'extracted int');
      expect(result.temperature, equals(22.1), reason: 'extracted double');
      expect(result.active, isTrue, reason: 'extracted bool');
    });
  });

  group('error handling', () {
    test('missing start tag ', () {
      var events = _eventsFrom('<badTag />');
      expect(attributesTag(events), throwsA(TypeMatcher<MissingStartTag>()));
    });
  });
}
