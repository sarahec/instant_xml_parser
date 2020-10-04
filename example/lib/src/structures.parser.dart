// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ParseMethodGenerator
// **************************************************************************

import 'dart:async';
import 'package:async/async.dart';
import 'package:xml/xml_events.dart';
import 'package:runtime/runtime.dart';
import 'structures.dart';

class Parser {
  final EmptyTagName = 'empty';

  final NameTagName = 'identification';

  final AttributesTagName = 'attributesTest';

  final RegistrationName = 'registration';

  final AltRegistrationName = 'AltRegistration';

  final ContactInfoName = 'ContactInfo';

  Future<AltRegistration> extractAltRegistration(
      StreamQueue<XmlEvent> events) async {
    final values = await pr.parse(events, AltRegistrationName, [
      GetAttr<String>('name'),
      GetAttr<String>('email'),
      GetAttr<int>('age')
    ]);
    return AltRegistration(values['name'], values['email'], values['age']);
  }

  Future<AttributesTag> extractAttributesTag(
      StreamQueue<XmlEvent> events) async {
    final values = await pr.parse(events, AttributesTagName, [
      GetAttr<String>('name'),
      GetAttr<int>('count'),
      GetAttr<double>('temperature'),
      GetAttr<bool>('active')
    ]);
    return AttributesTag(values['name'], values['count'], values['temperature'],
        values['active']);
  }

  Future<ContactInfo> extractContactInfo(StreamQueue<XmlEvent> events) async {
    final values = await pr.parse(events, ContactInfoName,
        [GetAttr<String>('email'), GetAttr<String>('phone')]);
    return ContactInfo(values['email'], values['phone']);
  }

  Future<EmptyTag> extractEmptyTag(StreamQueue<XmlEvent> events) async {
    final values = await pr.parse(events, EmptyTagName, []);
    return EmptyTag();
  }

  Future<NameTag> extractNameTag(StreamQueue<XmlEvent> events) async {
    final values =
        await pr.parse(events, NameTagName, [GetAttr<String>('name')]);
    return NameTag(values['name']);
  }

  Future<Registration> extractRegistration(StreamQueue<XmlEvent> events) async {
    final values = await pr.parse(events, RegistrationName, [
      GetTag<NameTag>(NameTagName, extractNameTag),
      GetTag<ContactInfo>(ContactInfoName, extractContactInfo),
      GetAttr<int>('age')
    ]);
    return Registration(values['person'], values['contact'], values['age']);
  }

  ParserRuntime get pr => ParserRuntime();
}
