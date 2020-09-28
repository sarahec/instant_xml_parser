import 'dart:async';
import 'package:async/async.dart';
import 'package:runtime/runtime.dart';
import 'package:xml/xml_events.dart';

import 'structures.dart';

Future<AttributesTag> extractAttributesTag(StreamQueue<XmlEvent> events) async {
  final startTag = startOf(events, name: 'attributesTest', rejectOthers: true);

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
  final startTag = startOf(events, name: 'emptyTag', rejectOthers: true);
  await endOf(startTag, events);
  return EmptyTag();
}

// @Tag('identification')
Future<NameTag> extractNameTag(StreamQueue<XmlEvent> events) async {
  final startTag = startOf(events, name: 'identification', rejectOthers: true);
  final name = await namedAttribute(startTag, 'name');
  await endOf(startTag, events);
  return NameTag(await name);
}

/*
// @Tag('registration')
Future<Registration> extractRegistration(StreamQueue<XmlEvent> events) async {
  final startTag = startOf(events, name: 'registration', rejectOthers: true);

  var nameTag =
      childOf(startTag, events, name: 'identification', action: extractNameTag);
  var contact = childOf(events,
      name: 'ContactInfo', parent: startTag, action: extractContacts);
  final age = namedAttribute(startTag, 'name');

  await endOf(startTag, events);
  return Registration(await nameTag, await contact, await age);
}
*/

// @Tag('ContactInfo')
Future<ContactInfo> extractContacts(StreamQueue<XmlEvent> events) async {
  final startTag = startOf(events, name: 'ContactInfo', rejectOthers: true);
  final email = await namedAttribute(startTag, 'email');
  final phone = await namedAttribute(startTag, 'phone');

  await endOf(startTag, events);
  return ContactInfo(email, phone);
}
