// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ParseMethodGenerator
// **************************************************************************

import 'dart:async';
import 'package:async/async.dart';
import 'package:xml/xml_events.dart';
import 'structures.dart';
import 'dart:core';
import 'package:logging/logging.dart';
import 'package:runtime/runtime.dart';

const AddressBookName = 'addressBook';
const AttributesTagName = 'attributesTest';
const ContactInfoName = 'ContactInfo';
const EmptyTagName = 'empty';
const NameTagName = 'identification';
const RegistrationName = 'registration';
final _log = Logger('parser');
Future<AddressBook> extractAddressBook(StreamQueue<XmlEvent> events,
    {optional = true}) async {
  final _addressBook =
      await events.findInTransaction(startTag(named(AddressBookName)))
          as XmlStartElementEvent;
  if (_addressBook == null) {
    return optional ? null : Future.error(MissingStartTag(AddressBookName));
  }
  _log.fine('in addressBook');

  var contacts = <ContactInfo>[];
  for (;;) {
    var probe = await events.findInTransaction(startTag(inside(_addressBook)),
        keepFound: true) as XmlStartElementEvent;
    if (probe == null) break;
    switch (probe.qualifiedName) {
      case ContactInfoName:
        contacts.add(await extractContactInfo(events));
        break;
      default:
        probe.logUnknown(expected: AddressBookName);
    }
  }
  _log.finest('consume addressBook');
  await events.consume(inside(_addressBook));
  return AddressBook(contacts);
}

Future<AttributesTag> extractAttributesTag(StreamQueue<XmlEvent> events,
    {optional = true}) async {
  final _attributesTag =
      await events.findInTransaction(startTag(named(AttributesTagName)))
          as XmlStartElementEvent;
  if (_attributesTag == null) {
    return optional ? null : Future.error(MissingStartTag(AttributesTagName));
  }
  _log.fine('in attributesTest');

  final name = await _attributesTag.namedAttribute<String>('name');
  final count = await _attributesTag.namedAttribute<int>('count') ?? 0;
  final temperature =
      await _attributesTag.namedAttribute<double>('temperature');
  final active = await _attributesTag.namedAttribute<bool>('active');

  _log.finest('consume attributesTest');
  await events.consume(inside(_attributesTag));
  return AttributesTag(name, temperature, active, count);
}

Future<ContactInfo> extractContactInfo(StreamQueue<XmlEvent> events,
    {optional = true}) async {
  final _contactInfo =
      await events.findInTransaction(startTag(named(ContactInfoName)))
          as XmlStartElementEvent;
  if (_contactInfo == null) {
    return optional ? null : Future.error(MissingStartTag(ContactInfoName));
  }
  _log.fine('in ContactInfo');

  final email = await _contactInfo.namedAttribute<String>('email');
  final phone = await _contactInfo.namedAttribute<String>('phone');
  final notes =
      (await events.findInTransaction(textElement(inside(_contactInfo)))
                  as XmlTextEvent)
              ?.text ??
          '';

  _log.finest('consume ContactInfo');
  await events.consume(inside(_contactInfo));
  return ContactInfo(email, phone: phone, notes: notes);
}

Future<EmptyTag> extractEmptyTag(StreamQueue<XmlEvent> events,
    {optional = true}) async {
  final _emptyTag = await events
      .findInTransaction(startTag(named(EmptyTagName))) as XmlStartElementEvent;
  if (_emptyTag == null) {
    return optional ? null : Future.error(MissingStartTag(EmptyTagName));
  }
  _log.fine('in empty');

  _log.finest('consume empty');
  await events.consume(inside(_emptyTag));
  return EmptyTag();
}

Future<NameTag> extractNameTag(StreamQueue<XmlEvent> events,
    {optional = true}) async {
  final _nameTag = await events.findInTransaction(startTag(named(NameTagName)))
      as XmlStartElementEvent;
  if (_nameTag == null) {
    return optional ? null : Future.error(MissingStartTag(NameTagName));
  }
  _log.fine('in identification');

  final name = await _nameTag.namedAttribute<String>('name');
  final nickname = (await events
          .findInTransaction(textElement(inside(_nameTag))) as XmlTextEvent)
      ?.text;

  _log.finest('consume identification');
  await events.consume(inside(_nameTag));
  return NameTag(name, nickname: nickname);
}

Future<Registration> extractRegistration(StreamQueue<XmlEvent> events,
    {optional = true}) async {
  final _registration =
      await events.findInTransaction(startTag(named(RegistrationName)))
          as XmlStartElementEvent;
  if (_registration == null) {
    return optional ? null : Future.error(MissingStartTag(RegistrationName));
  }
  _log.fine('in registration');

  final age = await _registration.namedAttribute<int>('age');

  var person;
  var contact;
  for (;;) {
    var probe = await events.findInTransaction(startTag(inside(_registration)),
        keepFound: true) as XmlStartElementEvent;
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
    }
  }
  _log.finest('consume registration');
  await events.consume(inside(_registration));
  return Registration(person, contact, age);
}
