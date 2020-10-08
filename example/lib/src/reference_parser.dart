import 'dart:async';

import 'package:async/async.dart';
import 'package:runtime/runtime.dart';
import 'package:xml/xml_events.dart';

import 'structures.dart';

class Parser {
  static const EmptyTagName = 'empty';

  static const AttributesTagName = 'attributesTest';

  static const NameTagName = 'identification';

  static const ContactInfoName = 'ContactInfo';

  static const RegistrationName = 'registration';

  ParserRuntime get _pr => ParserRuntime();

  Future<AttributesTag> extractAttributesTag(
      StreamQueue<XmlEvent> events) async {
    // start block
    final _attributesTag =
        await _pr.startOf(events, name: EmptyTagName, failOnMismatch: true);
    if (_attributesTag == null) return null;
    // parent attributes block
    final name = await _pr.namedAttribute<String>(_attributesTag, 'name');
    final count = await _pr.namedAttribute<int>(_attributesTag, 'count');
    final temperature =
        await _pr.namedAttribute<double>(_attributesTag, 'temperature');
    final active = await _pr.namedAttribute<bool>(_attributesTag, 'active');
    // end block
    await _pr.endOf(events, _attributesTag);
    // constructor block
    return AttributesTag(name, temperature, active, count ?? 0);
  }

  Future<ContactInfo> extractContactInfo(StreamQueue<XmlEvent> events) async {
    // start block
    final _contactInfo =
        await _pr.startOf(events, name: EmptyTagName, failOnMismatch: true);
    if (_contactInfo == null) return null;
    // parent attributes block
    final email = await _pr.namedAttribute<String>(_contactInfo, 'email');
    final phone = await _pr.namedAttribute<String>(_contactInfo, 'phone');
    // end block
    await _pr.endOf(events, _contactInfo);
    return ContactInfo(email, phone);
  }

  Future<EmptyTag> extractEmptyTag(StreamQueue<XmlEvent> events) async {
    // start block
    final _emptyTag =
        await _pr.startOf(events, name: EmptyTagName, failOnMismatch: true);
    if (_emptyTag == null) return null;
    // end block
    await _pr.endOf(events, _emptyTag);
    // constructor block
    return EmptyTag();
  }

  Future<NameTag> extractNameTag(StreamQueue<XmlEvent> events) async {
    // start block
    final _nameTag =
        await _pr.startOf(events, name: NameTagName, failOnMismatch: true);
    if (_nameTag == null) return null;
    // parent attributes block
    final name = await _pr.namedAttribute<String>(_nameTag, 'name');
    // end block
    await _pr.endOf(events, _nameTag);
    // constructor block
    return NameTag(name);
  }

  Future<Registration> extractRegistration(StreamQueue<XmlEvent> events) async {
    // start block
    final _registration =
        await _pr.startOf(events, name: RegistrationName, failOnMismatch: true);
    if (_registration == null) return null;
    // parent attributes block
    final age = await _pr.namedAttribute<int>(_registration, 'age');
    // child tag block
    var _nameTag;
    var _contactInfo;
    var probe = await _pr.startOf(events, parent: _registration);
    while (probe != null) {
      switch (probe.qualifiedName) {
        case NameTagName:
          _nameTag = await extractNameTag(events);
          break;

        case ContactInfoName:
          _contactInfo = await extractContactInfo(events);
          break;

        default:
          await _pr.logUnknown(probe, RegistrationName);
          await events.skip(1);
      }
      probe = await _pr.startOf(events, parent: _registration);
    }
    return Registration(_nameTag, _contactInfo, age);
  }
}
