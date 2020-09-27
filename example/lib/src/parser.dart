import 'dart:async';
import 'package:async/async.dart';
import 'package:runtime/runtime.dart';
import 'package:xml/xml_events.dart';

import 'structures.dart';

Future<AttributesTag> attributesTag(StreamQueue<XmlEvent> events) async {
  if (!(await hasStartTag(events, withName: 'attributesTest'))) {
    return Future.error(MissingStartTag('attributesTest'));
  }

  final startTag = await events.next as XmlStartElementEvent;
  final name = namedAttribute(startTag, 'name');
  final count = namedAttribute(startTag, 'count', (s) => int.parse(s));
  final temperature =
      namedAttribute(startTag, 'temperature', (s) => double.parse(s));
  final active =
      namedAttribute(startTag, 'active', (s) => s == '1' || s == 'true');

  while (await hasChildOf(events, startTag)) {
    // No children specified
    skip(await events.next);
  }

  return AttributesTag(name, count, temperature, active);
}
