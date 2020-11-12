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

  group('parsing', () {
    test('EmptyTag', () async {
      final events = _eventsFrom('<empty/>');
      final emptyTag = await extractEmptyTag(events);
      expect(emptyTag, isA<EmptyTag>());
    });

    test('core attributes', () async {
      final eventsFrom = _eventsFrom(
          '<attributesTest name="foo" count="999" temperature="22.1" active="1" />');
      final attributesTag = await extractAttributesTag(eventsFrom);
      expect(attributesTag, isA<AttributesTag>());
      expect(attributesTag.name, equals('foo'));
      expect(attributesTag.count, equals(999));
      expect(attributesTag.temperature, equals(22.1));
      expect(attributesTag.active, isTrue);
    });

    test('default attribute value', () async {
      final eventsFrom = _eventsFrom('<attributesTest  />');
      final attributesTag = await extractAttributesTag(eventsFrom);
      expect(attributesTag, isA<AttributesTag>());
      // missing attributes return null if no default specified in constructor
      expect(attributesTag.name, isNull);
      expect(attributesTag.count, equals(0)); // default from original source
      expect(attributesTag.temperature, isNull);
      expect(attributesTag.active, isNull);
    });

    test('NameTag', () async {
      final events = _eventsFrom('<identification name="bar"/>');
      final nameTag = await extractNameTag(events);
      expect(nameTag, isA<NameTag>());
      expect(nameTag.name, equals('bar'));
    });

    test('Registration (nested)', () async {
      final events = _eventsFrom(
          '<registration age="36"><identification name="bar"/><ContactInfo email="foo@bar.dev" phone="+1-213-867-5309"/></registration>');
      final registration = await extractRegistration(events);
      expect(registration, isA<Registration>());
      expect(registration.age, equals(36));
      expect(registration.person, isA<NameTag>());
      expect(registration.contact, isA<ContactInfo>());
      expect(registration.contact.email, equals('foo@bar.dev'));
    });

    test('address book', () async {
      final events = _eventsFrom(
          '<addressBook><ContactInfo email="alice@example.com" /><ContactInfo email="bob@example.com" /></addressBook>');
      final addressBook = await extractAddressBook(events);
      expect(addressBook, isNotNull);
      expect(
          addressBook.contacts,
          containsAllInOrder([
            ContactInfo('alice@example.com'),
            ContactInfo('bob@example.com')
          ]));
    });
  });

  group('integration', () {
    test('mixed sequence', () async {
      final events = _eventsFrom(
          '<registration age="36"><identification name="bar"/><ContactInfo email="foo@bar.dev" phone="+1-213-867-5309"/></registration><attributesTest name="foo" count="999" temperature="22.1" active="1" />');
      final registration = await extractRegistration(events);
      final attributes = await extractAttributesTag(events);
      expect(registration, isNotNull);
      expect(registration.age, equals(36));
      expect(registration.contact, isNotNull);
      expect(registration.person, isNotNull);
      expect(attributes, isNotNull);
      expect(attributes.name, equals('foo'));
    });
  });

  group('errors -', () {
    test('missing start tag ', () {
      final events = _eventsFrom('<badTag />');
      expect(extractEmptyTag(events), throwsA(TypeMatcher<MissingStartTag>()));
    });
  });
}
