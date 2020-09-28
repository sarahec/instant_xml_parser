import 'dart:async';
import 'package:async/async.dart';
import 'package:runtime/runtime.dart';
import 'package:xml/xml_events.dart';

import 'structures.dart';

Future<AttributesTag> extractAttributesTag(StreamQueue<XmlEvent> events) async {
  await requireStartTag(events, 'attributesTest');

  final startTag = await events.next as XmlStartElementEvent;
  final name = namedAttribute(startTag, 'name', isRequired: true);
  final count = namedAttribute(startTag, 'count',
      convert: Convert.toInt, defaultValue: 0);
  final temperature =
      namedAttribute(startTag, 'temperature', convert: Convert.toDouble);
  final active = namedAttribute(startTag, 'active', convert: Convert.toBool);

  await expectNoChildren(events, startTag);

  return AttributesTag(name, count, temperature, active);
}

// @Tag('empty', useStrict: true)
Future<EmptyTag> extractEmptyTag(StreamQueue<XmlEvent> events) async {
  await requireStartTag(events, 'emptyTag');

  final startTag = await events.next as XmlStartElementEvent;

  await expectNoChildren(events, startTag, shouldThrow: true);

  return EmptyTag();
}

// @Tag('identification')
Future<NameTag> extractNameTag(StreamQueue<XmlEvent> events) async {
  await requireStartTag(events, 'identification');
  final startTag = await events.next as XmlStartElementEvent;
  final name = namedAttribute(startTag, 'name');

  await expectNoChildren(events, startTag, shouldThrow: true);

  return NameTag(name);
}

// @Tag('registration')
Future<Registration> extractRegistration(StreamQueue<XmlEvent> events) async {
  await requireStartTag(events, 'registration');
  final tag = await events.next as XmlStartElementEvent;
  var nameTag;
  var contact;
  final age = namedAttribute(tag, 'age', convert: Convert.toInt);

  for (;;) {
    var _child = await nextStartTag(events, parent: tag);
    if (_child == null) break;
    switch (_child.name) {
      case 'identification':
        nameTag = await extractNameTag(events);
        break;

      case 'ContactInfo':
        contact = await extractContacts(events);
        break;

      default:
        reportUnknownChild(_child, parent: tag);
        // TODO Scan over to next child
        await events.skip(1);
    }
  }

  return Registration(nameTag, contact, age);
}

// @Tag('ContactInfo')
Future<ContactInfo> extractContacts(StreamQueue<XmlEvent> events) async {
  await requireStartTag(events, 'ContactInfo');
  final startTag = await events.next as XmlStartElementEvent;
  final email = namedAttribute(startTag, 'email');
  final phone = namedAttribute(startTag, 'phone');

  await expectNoChildren(events, startTag, shouldThrow: true);

  return ContactInfo(email, phone);
}
