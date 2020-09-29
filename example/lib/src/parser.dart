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
  final pr = ParserRuntime();
  final startTag =
      pr.startOf(events, name: AttributesTagName, mustBeFirst: true);

  final name = await pr.namedAttribute(startTag, 'name', isRequired: true);
  final count = await pr.namedAttribute(startTag, 'count',
      convert: Convert.toInt, defaultValue: 0);
  final temperature = await pr.namedAttribute(startTag, 'temperature',
      convert: Convert.toDouble);
  final active =
      await pr.namedAttribute(startTag, 'active', convert: Convert.toBool);

  await pr.endOf(startTag, events);
  return AttributesTag(name, count, temperature, active);
}

// @Tag('empty', useStrict: true)
Future<EmptyTag> extractEmptyTag(StreamQueue<XmlEvent> events) async {
  final pr = ParserRuntime();
  final startTag = pr.startOf(events, name: EmptyTagName, mustBeFirst: true);
  await pr.endOf(startTag, events);
  return EmptyTag();
}

// @Tag('identification')
Future<NameTag> extractNameTag(StreamQueue<XmlEvent> events) async {
  final pr = ParserRuntime();
  final startTag = pr.startOf(events, name: NameTagName, mustBeFirst: true);
  final name = await pr.namedAttribute(startTag, 'name');
  await pr.endOf(startTag, events);
  return NameTag(await name);
}

// @Tag('registration')
Future<Registration> extractRegistration(StreamQueue<XmlEvent> events) async {
  final pr = ParserRuntime();
  final startTag =
      pr.startOf(events, name: RegistrationTagName, mustBeFirst: true);
  final age = await pr.namedAttribute(startTag, 'age', convert: Convert.toInt);

  // Process child tags
  final dispatch = {
    NameTagName: extractNameTag,
    ContactInfoTagName: extractContacts
  };
  final childParser = ChildParser(dispatch, pr);
  final resultMap = await childParser.parseAll(events);
  // TODO get the skipped child list
  final nameTag = resultMap[NameTagName];
  final contact = resultMap[ContactInfoTagName];
  // TODO Extract any child attributes here

  await pr.endOf(startTag, events);
  return Registration(nameTag, contact, age);
}

// @Tag('ContactInfo')
Future<ContactInfo> extractContacts(StreamQueue<XmlEvent> events) async {
  final pr = ParserRuntime();
  final startTag =
      pr.startOf(events, name: ContactInfoTagName, mustBeFirst: true);
  final email = await pr.namedAttribute(startTag, 'email');
  final phone = await pr.namedAttribute(startTag, 'phone');

  await pr.endOf(startTag, events);
  return ContactInfo(email, phone);
}
