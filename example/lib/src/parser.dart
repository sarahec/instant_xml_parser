import 'dart:async';
import 'package:async/async.dart';
import 'package:runtime/runtime.dart';
import 'package:xml/xml_events.dart';

import 'structures.dart';

const AttributesTagName = 'attributesTest';
const EmptyTagName = 'emptyTag';
const NameTagName = 'identification';
const RegistrationTagName = 'registration';
const ContactInfoTagName = 'ContactInfo';

Future<AttributesTag> extractAttributesTag(StreamQueue<XmlEvent> events) async {
  final startTag = startOf(events, name: AttributesTagName, rejectOthers: true);

  final name = await namedAttribute(startTag, 'name', isRequired: true);
  final count = await namedAttribute(startTag, 'count',
      convert: Convert.toInt, defaultValue: 0);
  final temperature =
      await namedAttribute(startTag, 'temperature', convert: Convert.toDouble);
  final active =
      await namedAttribute(startTag, 'active', convert: Convert.toBool);

  await endOf(startTag, events);
  return AttributesTag(name, count, temperature, active);
}

// @Tag('empty', useStrict: true)
Future<EmptyTag> extractEmptyTag(StreamQueue<XmlEvent> events) async {
  final startTag = startOf(events, name: EmptyTagName, rejectOthers: true);
  await endOf(startTag, events);
  return EmptyTag();
}

// @Tag('identification')
Future<NameTag> extractNameTag(StreamQueue<XmlEvent> events) async {
  final startTag = startOf(events, name: NameTagName, rejectOthers: true);
  final name = await namedAttribute(startTag, 'name');
  await endOf(startTag, events);
  return NameTag(await name);
}

// @Tag('registration')
Future<Registration> extractRegistration(StreamQueue<XmlEvent> events) async {
  final startTag =
      startOf(events, name: RegistrationTagName, rejectOthers: true);
  final age = await namedAttribute(startTag, 'name');

  // Process child tags
  final parsers = {
    NameTagName: extractNameTag,
    ContactInfoTagName: extractContacts
  };
  final childParser = ChildParser(events, parsers);
  final resultMap = childParser.parseAll(events);
  // TODO get the skipped child list
  final nameTag = await resultMap[NameTagName];
  final contact = await resultMap[ContactInfoTagName];
  // TODO Extract any child attributes here

  await endOf(startTag, events);
  return Registration(nameTag, contact, age);
}

// @Tag('ContactInfo')
Future<ContactInfo> extractContacts(StreamQueue<XmlEvent> events) async {
  final startTag =
      startOf(events, name: ContactInfoTagName, rejectOthers: true);
  final email = await namedAttribute(startTag, 'email');
  final phone = await namedAttribute(startTag, 'phone');

  await endOf(startTag, events);
  return ContactInfo(email, phone);
}
