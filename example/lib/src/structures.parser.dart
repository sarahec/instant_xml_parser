// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ParseMethodGenerator
// **************************************************************************

import 'dart:async';
import 'package:async/async.dart';
import 'package:xml/xml_events.dart';
import 'package:runtime/runtime.dart';
import 'structures.dart';

const AttributesTagName = 'attributesTest';
const ContactInfoName = 'ContactInfo';
const EmptyTagName = 'empty';
const NameTagName = 'identification';
const RegistrationName = 'registration';

Future<AttributesTag> extractAttributesTag(StreamQueue<XmlEvent> events) async {
  final XmlStartElementEvent _attributesTag = await events.next;
  assert(_attributesTag?.qualifiedName == AttributesTagName,
      'expected $AttributesTagName');
  final name = await _attributesTag.namedAttribute<String>('name');
  final count = await _attributesTag.namedAttribute<int>('count') ?? 0;
  final temperature =
      await _attributesTag.namedAttribute<double>('temperature');
  final active = await _attributesTag.namedAttribute<bool>('active');
  await events.endOf(_attributesTag);
  return AttributesTag(name, temperature, active, count);
}

Future<ContactInfo> extractContactInfo(StreamQueue<XmlEvent> events) async {
  final XmlStartElementEvent _contactInfo = await events.next;
  assert(_contactInfo?.qualifiedName == ContactInfoName);
  final email = await _contactInfo.namedAttribute<String>('email');
  final phone = await _contactInfo.namedAttribute<String>('phone');
  await events.endOf(_contactInfo);
  return ContactInfo(email, phone);
}

Future<EmptyTag> extractEmptyTag(StreamQueue<XmlEvent> events) async {
  final XmlStartElementEvent _emptyTag = await events.next;
  assert(_emptyTag?.qualifiedName == EmptyTagName);
  await events.endOf(_emptyTag);
  return EmptyTag();
}

Future<NameTag> extractNameTag(StreamQueue<XmlEvent> events) async {
  final XmlStartElementEvent _nameTag = await events.next;
  assert(_nameTag?.qualifiedName == NameTagName);
  final name = await _nameTag.namedAttribute<String>('name');
  await events.endOf(_nameTag);
  return NameTag(name);
}

Future<Registration> extractRegistration(StreamQueue<XmlEvent> events) async {
  final XmlStartElementEvent _registration = await events.next;
  assert(_registration?.qualifiedName == RegistrationName);
  final age = await _registration.namedAttribute<int>('age');

  var person;
  var contact;
  while (!await events.atEnd(_registration)) {
    var probe = await events.nextStart(inside: _registration);
    if (probe == null) break;
    switch (probe.qualifiedName) {
      case NameTagName:
        person = await extractNameTag(events);
        break;
      case ContactInfoName:
        contact = await extractContactInfo(events);
        break;
      default:
        probe.logUnknown(expected: RegistrationName);
        await events.next;
    }
  }
  return Registration(person, contact, age);
}
