import 'dart:async';
import 'package:async/async.dart';
import 'package:xml/xml_events.dart';

Future<bool> hasStartTag(StreamQueue<XmlEvent> queue,
    {String withName, consume = false}) async {
  if (!await queue.hasNext) {
    return false;
  }
  final event = await (consume ? queue.next : queue.peek);
  return (event is XmlStartElementEvent) &&
      (withName == null || event.name == withName);
}

Future<XmlStartElementEvent> getParent(StreamQueue<XmlEvent> queue,
    {consume = false}) async {
  if (!await queue.hasNext) {
    return Future.error('Unexpected EOF');
  }
  final event = await (consume ? queue.next : queue.peek);
  return event.parentEvent;
}

Future<bool> hasChildOf(
    StreamQueue<XmlEvent> queue, XmlStartElementEvent startTag,
    {consume = false}) async {
  if (!await queue.hasNext) {
    return false;
  }
  final event = await (consume ? queue.next : queue.peek);
  return startTag == event.parentEvent;
}
