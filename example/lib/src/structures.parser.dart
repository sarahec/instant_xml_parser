// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ParseMethodGenerator
// **************************************************************************

import 'dart:async';
import 'package:async/async.dart';
import 'package:xml/xml_events.dart';
import 'structures.dart';
import 'dart:core';
import 'package:runtime/runtime.dart';

const AddressBookName = 'addressBook';
const AttributesTagName = 'attributesTest';
const ContactInfoName = 'ContactInfo';
const EmptyTagName = 'empty';
const NameTagName = 'identification';
const RegistrationName = 'registration';
Future<AddressBook> extractAddressBook(StreamQueue<XmlEvent> events) async {
  final _addressBook =
      await events.start(name: AddressBookName, throwsOnError: true);

  var contacts = <ContactInfo>[];
  var probe = _addressBook;
  for (;;) {
    probe = await events.start(after: probe);
    if (probe == null || await events.atEnd(_addressBook)) break;
    switch (probe.qualifiedName) {
      case ContactInfoName:
        contacts.add(await extractContactInfo(events));
        break;
      default:
        probe.logUnknown(expected: AddressBookName);
    }
  }
  await events.end(_addressBook);
  return AddressBook(contacts);
}

Future<AttributesTag> extractAttributesTag(StreamQueue<XmlEvent> events) async {
  final _attributesTag =
      await events.start(name: AttributesTagName, throwsOnError: true);
  final name = await _attributesTag.namedAttribute<String>('name');
  final count = await _attributesTag.namedAttribute<int>('count') ?? 0;
  final temperature =
      await _attributesTag.namedAttribute<double>('temperature');
  final active = await _attributesTag.namedAttribute<bool>('active');

  await events.end(_attributesTag);
  return AttributesTag(name, temperature, active, count);
}

Future<ContactInfo> extractContactInfo(StreamQueue<XmlEvent> events) async {
  final _contactInfo =
      await events.start(name: ContactInfoName, throwsOnError: true);
  final email = await _contactInfo.namedAttribute<String>('email');
  final phone = await _contactInfo.namedAttribute<String>('phone');
  final notes = await events.textValue() ?? '';

  await events.end(_contactInfo);
  return ContactInfo(email, phone: phone, notes: notes);
}

Future<EmptyTag> extractEmptyTag(StreamQueue<XmlEvent> events) async {
  final _emptyTag = await events.start(name: EmptyTagName, throwsOnError: true);

  await events.end(_emptyTag);
  return EmptyTag();
}

Future<NameTag> extractNameTag(StreamQueue<XmlEvent> events) async {
  final _nameTag = await events.start(name: NameTagName, throwsOnError: true);
  final name = await _nameTag.namedAttribute<String>('name');
  final nickname = await events.textValue();

  await events.end(_nameTag);
  return NameTag(name, nickname: nickname);
}

Future<Registration> extractRegistration(StreamQueue<XmlEvent> events) async {
  final _registration =
      await events.start(name: RegistrationName, throwsOnError: true);
  final age = await _registration.namedAttribute<int>('age');

  var person;
  var contact;
  var probe = _registration;
  for (;;) {
    probe = await events.start(after: probe);
    if (probe == null || await events.atEnd(_registration)) break;
    switch (probe.qualifiedName) {
      case NameTagName:
        person = await extractNameTag(events);
        break;
      case ContactInfoName:
        contact = await extractContactInfo(events);
        break;
      default:
        probe.logUnknown(expected: RegistrationName);
    }
  }
  await events.end(_registration);
  return Registration(person, contact, age);
}
