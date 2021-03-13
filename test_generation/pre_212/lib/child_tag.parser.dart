// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ParseMethodGenerator
// **************************************************************************

import 'dart:async';
import 'package:async/async.dart';
import 'package:xml/xml_events.dart';
import 'child_tag.dart';
import 'dart:core';
import 'package:logging/logging.dart';
import 'package:ixp_runtime/runtime.dart';

const ContactInfoName = 'contact';
const RegistrationName = 'registration';
final _log = Logger('parser');
Future<ContactInfo> extractContactInfo(StreamQueue<XmlEvent> events) async {
  final found = await events.scanTo(startTag(named(ContactInfoName)));
  if (!found) {
    throw MissingStartTag(ContactInfoName);
  }
  final _contactInfo = await events.peek as XmlStartElementEvent;
  _log.finest('in contact');

  final email = await _contactInfo.optionalAttribute<String>('email');
  final phone = await _contactInfo.optionalAttribute<String>('phone');

  _log.finest('consume contact');
  await events.consume(inside(_contactInfo));
  return ContactInfo(email, phone);
}

Future<Registration> extractRegistration(StreamQueue<XmlEvent> events) async {
  final found = await events.scanTo(startTag(named(RegistrationName)));
  if (!found) {
    throw MissingStartTag(RegistrationName);
  }
  final _registration = await events.peek as XmlStartElementEvent;
  _log.finest('in registration');

  final age = await _registration.optionalAttribute<int>('age') ?? 99;

  var contact = const ContactInfo();
  while (await events.scanTo(startTag(inside(_registration)))) {
    final probe = await events.peek as XmlStartElementEvent;
    switch (probe.qualifiedName) {
      case ContactInfoName:
        contact = await extractContactInfo(events);
        break;
      default:
        probe.logUnknown(expected: RegistrationName);
        await events.next;
    }
  }

  _log.finest('consume registration');
  await events.consume(inside(_registration));
  return Registration(contact: contact, age: age);
}
