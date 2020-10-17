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
  static const AttributesTagName = 'attributesTest';

  static const ContactInfoName = 'ContactInfo';

  static const EmptyTagName = 'empty';

  static const NameTagName = 'identification';

  static const RegistrationName = 'registration';

  Future<AttributesTag> extractAttributesTag(
      StreamQueue<XmlEvent> events) async {
    final _attributesTag = await _pr.startOf(events,
        name: AttributesTagName, failOnMismatch: true);
    if (_attributesTag == null) return null;
    final name = await _pr.namedAttribute<String>(_attributesTag, 'name');
    final count = await _pr.namedAttribute<int>(_attributesTag, 'count') ?? 0;
    final temperature =
        await _pr.namedAttribute<double>(_attributesTag, 'temperature');
    final active = await _pr.namedAttribute<bool>(_attributesTag, 'active');

    await _pr.endOf(events, _attributesTag);
    return AttributesTag(name, temperature, active, count);
  }

  Future<ContactInfo> extractContactInfo(StreamQueue<XmlEvent> events) async {
    final _contactInfo =
        await _pr.startOf(events, name: ContactInfoName, failOnMismatch: true);
    if (_contactInfo == null) return null;
    final email = await _pr.namedAttribute<String>(_contactInfo, 'email');
    final phone = await _pr.namedAttribute<String>(_contactInfo, 'phone');

    await _pr.endOf(events, _contactInfo);
    return ContactInfo(email, phone);
  }

  Future<EmptyTag> extractEmptyTag(StreamQueue<XmlEvent> events) async {
    final _emptyTag =
        await _pr.startOf(events, name: EmptyTagName, failOnMismatch: true);
    if (_emptyTag == null) return null;

    await _pr.endOf(events, _emptyTag);
    return EmptyTag();
  }

  Future<NameTag> extractNameTag(StreamQueue<XmlEvent> events) async {
    final _nameTag =
        await _pr.startOf(events, name: NameTagName, failOnMismatch: true);
    if (_nameTag == null) return null;
    final name = await _pr.namedAttribute<String>(_nameTag, 'name');

    await _pr.endOf(events, _nameTag);
    return NameTag(name);
  }

  Future<Registration> extractRegistration(StreamQueue<XmlEvent> events) async {
    final _registration =
        await _pr.startOf(events, name: RegistrationName, failOnMismatch: true);
    if (_registration == null) return null;
    final age = await _pr.namedAttribute<int>(_registration, 'age');

    var person;
    var contact;
    var probe = await _pr.startOf(events, parent: _registration);
    while (probe != null) {
      switch (probe.qualifiedName) {
        case NameTagName:
          person = await extractNameTag(events);
          break;
        case ContactInfoName:
          contact = await extractContactInfo(events);
          break;
        default:
          await _pr.logUnknown(probe, RegistrationName);
          await _pr.consume(events, 1);
      }
      probe = await _pr.startOf(events, parent: _registration);
    }
    await _pr.endOf(events, _registration);
    return Registration(person, contact, age);
  }

  ParserRuntime get _pr => ParserRuntime();
  StreamQueue<XmlEvent> generateEventStream(Stream<String> source) =>
      StreamQueue(
          source.toXmlEvents().withParentEvents().normalizeEvents().flatten());
}
