import 'dart:async';
import 'package:async/async.dart';
import 'package:runtime/runtime.dart';
import 'package:xml/xml_events.dart';

import 'structures.dart';

FutureOr<EmptyTag> emptyTag(StreamQueue<XmlEvent> events) async {
  const tag = 'empty';

  if (!(await hasStartTag(events, withName: tag))) {
    return Future.error('Expected <empty> at start');
  }
  var startTag = await events.next as XmlStartElementEvent;

  while (await hasChildOf(events, startTag)) {
    var probe = await events.next;
    print(probe);
    // <<< gather fields
  }

  return EmptyTag();
}

FutureOr<NamedTag> namedTag(StreamQueue<XmlEvent> events) async {
  const tag = 'named';
  var name;
  if (!(await hasStartTag(events, withName: tag))) {
    return Future.error('Expected <named> at start');
  }
  var startTag = await events.next as XmlStartElementEvent;
  name = namedAttribute(startTag, 'name');

  while (await hasChildOf(events, startTag)) {
    var probe = await events.next;
    print(probe);
    // <<< gather fields
  }

  return NamedTag(name);
}

FutureOr<AttributesTag> attributesTag(StreamQueue<XmlEvent> events) async {
  const tag = 'attributesTest';
  var name;
  var count;
  var temperature;
  var active;
  if (!(await hasStartTag(events, withName: tag))) {
    return Future.error('Expected <attributesTest> at start');
  }
  var startTag = await events.next as XmlStartElementEvent;
  name = namedAttribute(startTag, 'name');
  count = namedAttribute(startTag, 'count', (s) => int.parse(s));
  temperature = namedAttribute(startTag, 'temperature', (s) => double.parse(s));
  active = namedAttribute(startTag, 'active', (s) => s == '1' || s == 'true');

  while (await hasChildOf(events, startTag)) {
    var probe = await events.next;
    print(probe);
    // <<< gather fields
  }

  return AttributesTag(name, count, temperature, active);
}
