// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ParseMethodGenerator
// **************************************************************************

import 'dart:async';
import 'package:async/async.dart';
import 'package:xml/xml_events.dart';
import 'imports.dart';
import 'other.dart';
import 'dart:core';
import 'package:logging/logging.dart';
import 'package:ixp_runtime/ixp_runtime.dart';

const ContactInfoName = 'contact';
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
