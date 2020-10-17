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
Future<AttributesTag> extractAttributesTag(
    StreamQueue<XmlEvent> events, ParserRuntime pr) async {
  final _attributesTag =
      await pr.startOf(events, name: AttributesTagName, failOnMismatch: true);
  if (_attributesTag == null) return null;
  final name = await pr.namedAttribute<String>(_attributesTag, 'name');
  final count = await pr.namedAttribute<int>(_attributesTag, 'count') ?? 0;
  final temperature =
      await pr.namedAttribute<double>(_attributesTag, 'temperature');
  final active = await pr.namedAttribute<bool>(_attributesTag, 'active');

  await pr.endOf(events, _attributesTag);
  return AttributesTag(name, temperature, active, count);
}

Future<ContactInfo> extractContactInfo(
    StreamQueue<XmlEvent> events, ParserRuntime pr) async {
  final _contactInfo =
      await pr.startOf(events, name: ContactInfoName, failOnMismatch: true);
  if (_contactInfo == null) return null;
  final email = await pr.namedAttribute<String>(_contactInfo, 'email');
  final phone = await pr.namedAttribute<String>(_contactInfo, 'phone');

  await pr.endOf(events, _contactInfo);
  return ContactInfo(email, phone);
}

Future<EmptyTag> extractEmptyTag(
    StreamQueue<XmlEvent> events, ParserRuntime pr) async {
  final _emptyTag =
      await pr.startOf(events, name: EmptyTagName, failOnMismatch: true);
  if (_emptyTag == null) return null;

  await pr.endOf(events, _emptyTag);
  return EmptyTag();
}

Future<NameTag> extractNameTag(
    StreamQueue<XmlEvent> events, ParserRuntime pr) async {
  final _nameTag =
      await pr.startOf(events, name: NameTagName, failOnMismatch: true);
  if (_nameTag == null) return null;
  final name = await pr.namedAttribute<String>(_nameTag, 'name');

  await pr.endOf(events, _nameTag);
  return NameTag(name);
}

Future<Registration> extractRegistration(
    StreamQueue<XmlEvent> events, ParserRuntime pr) async {
  final _registration =
      await pr.startOf(events, name: RegistrationName, failOnMismatch: true);
  if (_registration == null) return null;
  final age = await pr.namedAttribute<int>(_registration, 'age');

  var person;
  var contact;
  var probe = await pr.startOf(events, parent: _registration);
  while (probe != null) {
    switch (probe.qualifiedName) {
      case NameTagName:
        person = await extractNameTag(events, pr);
        break;
      case ContactInfoName:
        contact = await extractContactInfo(events, pr);
        break;
      default:
        await pr.logUnknown(probe, RegistrationName);
        await pr.consume(events, 1);
    }
    probe = await pr.startOf(events, parent: _registration);
  }
  await pr.endOf(events, _registration);
  return Registration(person, contact, age);
}
