import 'dart:async';
import 'package:async/async.dart';
import 'package:runtime/runtime.dart';
import 'package:xml/xml_events.dart';

import 'structures.dart';

const AttributesTagName = 'attributesTest';
const EmptyTagName = 'emptyTag';
const NameTagName = 'identification';
const RegistrationTagName = 'registration';
const ContactInfoTagName = 'ContactInfo';

class TestXmlParser {
  final pr = ParserRuntime();

  Future<AttributesTag> extractAttributesTag(
      StreamQueue<XmlEvent> events) async {
    final values = await pr.parse(events, AttributesTagName, [
      GetAttr<int>('count', defaultValue: 0),
      GetAttr<double>('temperature'),
      GetAttr<bool>('active'),
      GetAttr<String>('name', isRequired: true),
    ]);
    return AttributesTag(values['name'], values['count'], values['temperature'],
        values['active']);
  }

// @Tag('empty', useStrict: true)
  Future<EmptyTag> extractEmptyTag(StreamQueue<XmlEvent> events) async {
    await pr.parse(events, EmptyTagName, []);
    return EmptyTag();
  }

// @Tag('identification')
  Future<NameTag> extractNameTag(StreamQueue<XmlEvent> events) async {
    final values = await pr.parse(events, NameTagName, [
      GetAttr<String>('name', isRequired: true),
    ]);
    return NameTag(values['name']);
  }

// @Tag('registration')
  Future<Registration> extractRegistration(StreamQueue<XmlEvent> events) async {
    final values = await pr.parse(events, RegistrationTagName, [
      GetAttr<int>('age', isRequired: true),
      GetTag(NameTagName, extractNameTag),
      GetTag(ContactInfoTagName, extractContacts),
    ]);
    return Registration(
        values[NameTagName], values[ContactInfoTagName], values['age']);
  }

// @Tag('ContactInfo')
  Future<ContactInfo> extractContacts(StreamQueue<XmlEvent> events) async {
    final values = await pr.parse(events, ContactInfoTagName, [
      GetAttr<String>('email'),
      GetAttr<String>('phone'),
    ]);
    return ContactInfo(values['email'], values['phone']);
  }
}
