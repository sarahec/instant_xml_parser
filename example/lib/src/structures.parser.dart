// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ParseMethodGenerator
// **************************************************************************

import 'dart:async';
import 'package:async/async.dart';
import 'package:xml/xml_events.dart';
import 'package:runtime/runtime.dart';
import 'package:runtime/runtime.dart';
import 'structures.dart';

class Parser {
  final EmptyTagTagName = 'EmptyTag';

  final NameTagTagName = 'NameTag';

  final AttributesTagTagName = 'AttributesTag';

  final RegistrationTagName = 'Registration';

  final AltRegistrationTagName = 'AltRegistration';

  final ContactInfoTagName = 'ContactInfo';

  Future<EmptyTag> extractEmptyTag(StreamQueue<XmlEvent> events) async {
    final emptyTag = await pr.parse(events, EmptyTagTagName, []);
    return EmptyTag();
  }

  Future<NameTag> extractNameTag(StreamQueue<XmlEvent> events) async {
    final nameTag =
        await pr.parse(events, NameTagTagName, [GetAttr<String>('null ')]);
    return NameTag();
  }

  Future<AttributesTag> extractAttributesTag(
      StreamQueue<XmlEvent> events) async {
    final attributesTag = await pr.parse(events, AttributesTagTagName, [
      GetAttr<String>('null '),
      GetAttr<int>('null '),
      GetAttr<double>('null '),
      GetAttr<bool>('null ')
    ]);
    return AttributesTag();
  }

  Future<Registration> extractRegistration(StreamQueue<XmlEvent> events) async {
    final registration = await pr.parse(events, RegistrationTagName, [
      GetTag<NameTag>(NameTagTagName, events),
      GetTag<ContactInfo>(ContactInfoTagName, events),
      GetAttr<int>('null ')
    ]);
    return Registration();
  }

  Future<AltRegistration> extractAltRegistration(
      StreamQueue<XmlEvent> events) async {
    final altRegistration = await pr.parse(events, AltRegistrationTagName, [
      GetAttr<String>('null '),
      GetAttr<String>('null '),
      GetAttr<int>('null ')
    ]);
    return AltRegistration();
  }

  Future<ContactInfo> extractContactInfo(StreamQueue<XmlEvent> events) async {
    final contactInfo = await pr.parse(events, ContactInfoTagName,
        [GetAttr<String>('null '), GetAttr<String>('null ')]);
    return ContactInfo();
  }

  ParserRuntime get pr => ParserRuntime();
}
