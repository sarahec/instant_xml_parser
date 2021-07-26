// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
import 'package:async/async.dart';
import 'package:example/example.dart';
import 'package:ixp_runtime/ixp_runtime.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';
import 'package:xml/xml_events.dart';

void main() {
  StreamQueue<XmlEvent> _eventsFrom(String xml) => StreamQueue(Stream.value(xml)
      .toXmlEvents()
      .withParentEvents()
      .normalizeEvents()
      .flatten());

  Logger.root.onRecord.listen((record) {
    print('${record.loggerName} ${record.time}: ${record.message}');
  });

  group('parsing', () {
    setUp(() => Logger.root.level = Level.INFO);

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

    test('missing attribute', () async {
      final eventsFrom = _eventsFrom('<attributesTest />');
      expect(extractAttributesTag(eventsFrom),
          throwsA(TypeMatcher<MissingAttribute>()));
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
      try {
        final registration = await extractRegistration(events);
        expect(registration, isA<Registration>());
        expect(registration.age, equals(36));
        expect(registration.person, isA<NameTag>());
        expect(registration.contact, isA<ContactInfo>());
        expect(registration.contact!.email, equals('foo@bar.dev'));
      } catch (e) {
        print(e.toString());
      }
    });

    test('address book', () async {
      final events = _eventsFrom(
          '<addressBook><ContactInfo email="alice@example.com">Birthday: April 1</ContactInfo><ContactInfo email="bob@example.com">Birthday: Oct 31</ContactInfo></addressBook>');
      final addressBook = await extractAddressBook(events);
      expect(addressBook, isNotNull);
      expect(
          addressBook.contacts,
          containsAllInOrder([
            ContactInfo('alice@example.com', notes: 'Birthday: April 1'),
            ContactInfo('bob@example.com', notes: 'Birthday: Oct 31')
          ]));
    });
  });
  group('integration', () {
    test('homogeneous events', () async {
      final events =
          _eventsFrom('<notebook><note>a</note><note>b</note></notebook>');
      final notebook = await extractNotebook(events);
      expect(notebook, isNotNull);
      expect(notebook.notes.length, equals(2));
    });

    test('mixed sequence', () async {
      // Logger.root.level = Level.ALL;
      final events = _eventsFrom(
          '<test><registration age="36"><identification name="bar" /><ContactInfo email="foo@bar.dev" phone="+1-213-867-5309" /></registration><attributesTest name="foo" count="999" temperature="22.1" active="1" /></test>');
      final registration = await extractRegistration(events);
      expect(registration, isNotNull, reason: 'registration');
      expect(registration.age, equals(36));
      expect(registration.contact, isNotNull, reason: 'contact');
      expect(registration.person, isNotNull, reason: 'name tag');

      final attributes = await extractAttributesTag(events);
      expect(attributes, isNotNull, reason: 'attributes');
      expect(attributes.name, equals('foo'));
    });
  });
}
