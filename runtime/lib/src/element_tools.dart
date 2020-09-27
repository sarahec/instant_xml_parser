import 'dart:async';
import 'package:async/async.dart';
import 'package:xml/xml_events.dart';

import 'errors.dart';
import 'logging.dart';

Future<bool> hasStartTag(StreamQueue<XmlEvent> queue,
    {String withName, consume = false}) async {
  log.v('hasStartTag:');
  if (!await queue.hasNext) {
    return Future.error(EndOfQueue());
  }
  final event = await (consume ? queue.next : queue.peek);
  log.v(event);
  return (event is XmlStartElementEvent) &&
      (withName == null || event.name == withName);
}

Future<XmlStartElementEvent> getParent(StreamQueue<XmlEvent> queue,
    {consume = false}) async {
  log.v('getParent:');
  if (!await queue.hasNext) {
    return Future.error(EndOfQueue());
  }
  final event = await (consume ? queue.next : queue.peek);
  log.v(event);
  return event.parentEvent;
}

Future<bool> hasChildOf(
    StreamQueue<XmlEvent> queue, XmlStartElementEvent startTag,
    {consume = false}) async {
  log.v('hasChildOf:');
  if (!await queue.hasNext) {
    log.v('eof');
    return false;
  }
  final event = await (consume ? queue.next : queue.peek);
  log.v(event);
  return startTag == event.parentEvent;
}
