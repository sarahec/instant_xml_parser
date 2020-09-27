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
      expect(result.name, equals('foo'));
      expect(result.count, equals(999));
      expect(result.temperature, equals(22.1));
      expect(result.active, isTrue);
    });

    test('populates default values', () async {
      var result =
          await attributesTag(_eventsFrom('<attributesTest name="foo" />'));
      expect(result, isA<AttributesTag>());
      expect(result.name, equals('foo'));
      expect(result.count, equals(0));
      expect(result.temperature, isNull);
      expect(result.active, isNull);
    });
  });

  group('error handling', () {
    test('missing start tag ', () {
      var events = _eventsFrom('<badTag />');
      expect(emptyTag(events), throwsA(TypeMatcher<MissingStartTag>()));
    });

    test('unexpected children in strict mode ', () {
      var events = _eventsFrom('<emptyTag><foo/></emptyTag>');
      expect(emptyTag(events), throwsA(TypeMatcher<UnexpectedChild>()));
    });

    test('missing required attribute', () async {
      var events = _eventsFrom('<attributesTest />');
      expect(attributesTag(events), throwsA(TypeMatcher<MissingAttribute>()));
    });
  });
}
