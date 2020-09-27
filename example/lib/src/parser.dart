import 'dart:async';
import 'package:async/async.dart';
import 'package:runtime/runtime.dart';
import 'package:xml/xml_events.dart';

import 'structures.dart';

Future<AttributesTag> attributesTag(StreamQueue<XmlEvent> events) async {
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
Future<EmptyTag> emptyTag(StreamQueue<XmlEvent> events) async {
  await requireStartTag(events, 'emptyTag');

  final startTag = await events.next as XmlStartElementEvent;

  await expectNoChildren(events, startTag, shouldThrow: true);

  return EmptyTag();
}
