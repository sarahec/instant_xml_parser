// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ParseMethodGenerator
// **************************************************************************

import 'package:async/async.dart';
import 'package:xml/xml_events.dart';
import 'structures.dart';
import 'dart:core';
import 'package:logging/logging.dart';
import 'package:ixp_runtime/ixp_runtime.dart';

const AddressBookName = 'addressBook';
const AttributesTagName = 'attributesTest';
const ContactInfoName = 'ContactInfo';
const EmptyTagName = 'empty';
const NameTagName = 'identification';
const NoteName = 'note';
const NotebookName = 'notebook';
const RegistrationName = 'registration';
final _log = Logger('parser');
Future<AddressBook> extractAddressBook(StreamQueue<XmlEvent> events) async {
  final found = await events.scanTo(startTag(named(AddressBookName)));
  if (!found) {
    throw MissingStartTag(AddressBookName);
  }
  final _addressBook = await events.next as XmlStartElementEvent;
  _log.finest('in addressBook');

  var contacts = <ContactInfo>[];
  while (await events.scanTo(startTag(inside(_addressBook)))) {
    final probe = await events.peek as XmlStartElementEvent;
    switch (probe.qualifiedName) {
      case ContactInfoName:
        contacts.add(await extractContactInfo(events));
        break;
      default:
        probe.logUnknown(expected: AddressBookName);
        await events.next;
    }
  }

  await events.consume(inside(_addressBook));
  return AddressBook(contacts);
}

Future<AttributesTag> extractAttributesTag(StreamQueue<XmlEvent> events) async {
  final found = await events.scanTo(startTag(named(AttributesTagName)));
  if (!found) {
    throw MissingStartTag(AttributesTagName);
  }
  final _attributesTag = await events.next as XmlStartElementEvent;
  _log.finest('in attributesTest');

  final name = await _attributesTag.attribute<String>('name');
  final temperature =
      await _attributesTag.optionalAttribute<double>('temperature');
  final active = await _attributesTag.optionalAttribute<bool>('active');
  final count = await _attributesTag.optionalAttribute<int>('count') ?? 0;

  await events.consume(inside(_attributesTag));
  return AttributesTag(name, temperature, active, count);
}

Future<ContactInfo> extractContactInfo(StreamQueue<XmlEvent> events) async {
  final found = await events.scanTo(startTag(named(ContactInfoName)));
  if (!found) {
    throw MissingStartTag(ContactInfoName);
  }
  final _contactInfo = await events.next as XmlStartElementEvent;
  _log.finest('in ContactInfo');

  final email = await _contactInfo.optionalAttribute<String>('email');
  final phone = await _contactInfo.optionalAttribute<String>('phone');
  var notes;
  if (await events.scanTo(textElement(inside(_contactInfo)))) {
    notes = (await events.peek as XmlTextEvent).value;
  } else {
    notes = '';
  }

  await events.consume(inside(_contactInfo));
  return ContactInfo(email, phone: phone, notes: notes);
}

Future<EmptyTag> extractEmptyTag(StreamQueue<XmlEvent> events) async {
  final found = await events.scanTo(startTag(named(EmptyTagName)));
  if (!found) {
    throw MissingStartTag(EmptyTagName);
  }
  final _emptyTag = await events.next as XmlStartElementEvent;
  _log.finest('in empty');

  await events.consume(inside(_emptyTag));
  return EmptyTag();
}

Future<NameTag> extractNameTag(StreamQueue<XmlEvent> events) async {
  final found = await events.scanTo(startTag(named(NameTagName)));
  if (!found) {
    throw MissingStartTag(NameTagName);
  }
  final _nameTag = await events.next as XmlStartElementEvent;
  _log.finest('in identification');

  final name = await _nameTag.optionalAttribute<String>('name');
  var nickname;
  if (await events.scanTo(textElement(inside(_nameTag)))) {
    nickname = (await events.peek as XmlTextEvent).value;
  }

  await events.consume(inside(_nameTag));
  return NameTag(name, nickname: nickname);
}

Future<Note> extractNote(StreamQueue<XmlEvent> events) async {
  final found = await events.scanTo(startTag(named(NoteName)));
  if (!found) {
    throw MissingStartTag(NoteName);
  }
  final _note = await events.next as XmlStartElementEvent;
  _log.finest('in note');

  var text;
  if (await events.scanTo(textElement(inside(_note)))) {
    text = (await events.peek as XmlTextEvent).value;
  } else {
    throw MissingText(NoteName, element: _note);
  }

  await events.consume(inside(_note));
  return Note(text);
}

Future<Notebook> extractNotebook(StreamQueue<XmlEvent> events) async {
  final found = await events.scanTo(startTag(named(NotebookName)));
  if (!found) {
    throw MissingStartTag(NotebookName);
  }
  final _notebook = await events.next as XmlStartElementEvent;
  _log.finest('in notebook');

  var notes = <Note>[];
  while (await events.scanTo(startTag(inside(_notebook)))) {
    final probe = await events.peek as XmlStartElementEvent;
    switch (probe.qualifiedName) {
      case NoteName:
        notes.add(await extractNote(events));
        break;
      default:
        probe.logUnknown(expected: NotebookName);
        await events.next;
    }
  }

  await events.consume(inside(_notebook));
  return Notebook(notes);
}

Future<Registration> extractRegistration(StreamQueue<XmlEvent> events) async {
  final found = await events.scanTo(startTag(named(RegistrationName)));
  if (!found) {
    throw MissingStartTag(RegistrationName);
  }
  final _registration = await events.next as XmlStartElementEvent;
  _log.finest('in registration');

  final age = await _registration.optionalAttribute<int>('age');

  var person;
  var contact;
  while (await events.scanTo(startTag(inside(_registration)))) {
    final probe = await events.peek as XmlStartElementEvent;
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

  await events.consume(inside(_registration));
  return Registration(person, contact, age);
}
