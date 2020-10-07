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

  final AttributesTagName = 'attributesTest';

  final NameTagName = 'identification';

  final ContactInfoName = 'ContactInfo';

  final RegistrationName = 'registration';

  Future<AttributesTag> extractAttributesTag(
      StreamQueue<XmlEvent> events) async {
    final values = await pr.parse(events, AttributesTagName, [
      GetAttr<String>('name', key: 'name'),
      GetAttr<int>('count', key: 'count'),
      GetAttr<double>('temperature', key: 'temperature'),
      GetAttr<bool>('active', key: 'active')
    ]);
    return AttributesTag(values['name'], values['temperature'],
        values['active'], values['count']);
  }

  Future<ContactInfo> extractContactInfo(StreamQueue<XmlEvent> events) async {
    final values = await pr.parse(events, ContactInfoName, [
      GetAttr<String>('email', key: 'email'),
      GetAttr<String>('phone', key: 'phone')
    ]);
    return ContactInfo(values['email'], values['phone']);
  }

  Future<EmptyTag> extractEmptyTag(StreamQueue<XmlEvent> events) async {
    final values = await pr.parse(events, EmptyTagName, []);
    return EmptyTag();
  }

  Future<NameTag> extractNameTag(StreamQueue<XmlEvent> events) async {
    final values = await pr
        .parse(events, NameTagName, [GetAttr<String>('name', key: 'name')]);
    return NameTag(values['name']);
  }

  Future<Registration> extractRegistration(StreamQueue<XmlEvent> events) async {
    final values = await pr.parse(events, RegistrationName, [
      GetTag<NameTag>(NameTagName, extractNameTag, key: 'person'),
      GetTag<ContactInfo>(ContactInfoName, extractContactInfo, key: 'contact'),
      GetAttr<int>('age', key: 'age')
    ]);
    return Registration(values['person'], values['contact'], values['age']);
  }

  ParserRuntime get pr => ParserRuntime();
}
