import 'dart:async';
import 'package:async/async.dart';
import 'package:runtime/runtime.dart';
import 'package:xml/xml_events.dart';

import 'structures.dart';

Future<AttributesTag> extractAttributesTag(StreamQueue<XmlEvent> events) async {
  await requireStartTag(events, 'attributesTest');

  final startTag = await events.next as XmlStartElementEvent;
  final name = namedAttribute(startTag, 'name', isRequired: true);
  final count = namedAttribute(startTag, 'count',
      convert: Convert.toInt, defaultValue: 0);
  final temperature =
      namedAttribute(startTag, 'temperature', convert: Convert.toDouble);
  final active = namedAttribute(startTag, 'active', convert: Convert.toBool);

  await expectNoChildren(events, startTag);

  return AttributesTag(name, count, temperature, active);
}

// @Tag('empty', useStrict: true)
Future<EmptyTag> extractEmptyTag(StreamQueue<XmlEvent> events) async {
  await requireStartTag(events, 'emptyTag');

  final startTag = await events.next as XmlStartElementEvent;

  await expectNoChildren(events, startTag, shouldThrow: true);

  return EmptyTag();
}

// @Tag('named')
Future<NamedTag> extractNamedTag(StreamQueue<XmlEvent> events) async {
  await requireStartTag(events, 'namedTag');
  final startTag = await events.next as XmlStartElementEvent;
  final name = namedAttribute(startTag, 'name');

  await expectNoChildren(events, startTag, shouldThrow: true);

  return NamedTag(name);
}

// @Tag('named')
Future<Registration> extractRegistration(StreamQueue<XmlEvent> events) async {
  await requireStartTag(events, 'registration');
  final tag = await events.next as XmlStartElementEvent;
  var namedTag;
  final age = namedAttribute(tag, 'age', convert: Convert.toInt);

  for (;;) {
    // TODO Wrap nextStartTag as an Iterator
    var _child = await nextStartTag(events, parent: tag);
    if (_child == null) break;
    switch (_child.name) {
      case 'namedTag':
        namedTag = await extractNamedTag(events);
        break;
      default:
        reportUnknownChild(_child, parent: tag);
    }
  }

  return Registration(namedTag, age);
}
