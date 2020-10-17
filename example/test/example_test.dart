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

  final txp = Parser();

  group('extraction', () {
    test('EmptyTag', () async {
      final events = _eventsFrom('<empty/>');
      final emptyTag = await txp.extractEmptyTag(events);
      expect(emptyTag, isA<EmptyTag>());
    });

    test('core attributes', () async {
      final eventsFrom = _eventsFrom(
          '<attributesTest name="foo" count="999" temperature="22.1" active="1" />');
      final attributesTag = await txp.extractAttributesTag(eventsFrom);
      expect(attributesTag, isA<AttributesTag>());
      expect(attributesTag.name, equals('foo'));
      expect(attributesTag.count, equals(999));
      expect(attributesTag.temperature, equals(22.1));
      expect(attributesTag.active, isTrue);
    });

    test('default attribute value', () async {
      final eventsFrom = _eventsFrom('<attributesTest  />');
      final attributesTag = await txp.extractAttributesTag(eventsFrom);
      expect(attributesTag, isA<AttributesTag>());
      // missing attributes return null if no default specified in constructor
      expect(attributesTag.name, isNull);
      expect(attributesTag.count, equals(0)); // default from original source
      expect(attributesTag.temperature, isNull);
      expect(attributesTag.active, isNull);
    });

    test('NameTag', () async {
      final events = _eventsFrom('<identification name="bar"/>');
      final nameTag = await txp.extractNameTag(events);
      expect(nameTag, isA<NameTag>());
      expect(nameTag.name, equals('bar'));
    });

    test('Registration (nested)', () async {
      final events = _eventsFrom(
          '<registration age="36"><identification name="bar"/><ContactInfo email="foo@bar.dev" phone="+1-213-867-5309"/></registration>');
      final registration = await txp.extractRegistration(events);
      expect(registration, isA<Registration>());
      expect(registration.age, equals(36));
      expect(registration.person, isA<NameTag>());
      expect(registration.contact, isA<ContactInfo>());
      expect(registration.contact.email, equals('foo@bar.dev'));
    });
  });

  group('errors -', () {
    test('missing start tag ', () {
      final events = _eventsFrom('<badTag />');
      expect(
          txp.extractEmptyTag(events), throwsA(TypeMatcher<MissingStartTag>()));
    });
  });
}
