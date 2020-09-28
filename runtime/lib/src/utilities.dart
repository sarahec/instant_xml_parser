import 'dart:async';

import 'package:async/async.dart';
import 'package:meta/meta.dart';
import 'package:xml/xml_events.dart';

import 'converters.dart';
import 'errors.dart';
import 'logging.dart';

void expectNoChildren(
    StreamQueue<XmlEvent> events, XmlStartElementEvent startTag,
    {shouldThrow = false}) async {
  if (!startTag.isSelfClosing) {
    await skipChildren(events, startTag, shouldThrow: shouldThrow);
  }
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

Future<XmlStartElementEvent> nextStartTag(StreamQueue<XmlEvent> queue,
    {@required XmlStartElementEvent parent, discardOthers = true}) async {
  log.v('nextStartTag:');
  while (await queue.hasNext) {
    var event = await queue.peek;
    if (event.parentEvent != parent) {
      log.v('exiting due to parent change');
      return null;
    }
    if (event is XmlStartElementEvent) {
      return event;
    } else {
      if (discardOthers) {
        await queue.next;
      }
    }
  }
  return null;
}

T namedAttribute<T>(XmlStartElementEvent element, String attributeName,
    {Converter<T> convert, isRequired = false, T defaultValue}) {
  assert(convert != null || !(T is String),
      'converter required for non-String attributes');

  final attribute = element.attributes
      .firstWhere((a) => a.name == attributeName, orElse: () => null);
  final value = attribute?.value;

  if (attribute?.value == null) {
    if (isRequired) {
      throw MissingAttribute(element.name, attributeName);
    } else {
      return attribute?.value ?? defaultValue;
    }
  }
  return convert == null ? value : convert(value);
}

void reportUnknownChild(XmlStartElementEvent child,
    {@required XmlStartElementEvent parent, shouldThrow = false}) {
  log.w('Unknown child <${child.name} inside <${parent.name}>');
  if (shouldThrow) {
    throw (UnexpectedChild(child.name));
  }
}

void requireStartTag(StreamQueue<XmlEvent> events, String tag) async {
  if (!(await hasStartTag(events, withName: tag))) {
    throw (MissingStartTag(tag));
  }
}

void skip(XmlEvent event) {
  if (event is XmlStartElementEvent) {
    log.d('Skipped: START <${event.name}>');
  } else {
    log.v('Skipped $event');
  }
}

void skipChildren(StreamQueue<XmlEvent> events, XmlStartElementEvent startTag,
    {shouldThrow = false}) async {
  while (await hasChildOf(events, startTag)) {
    if (shouldThrow) {
      throw (UnexpectedChild(startTag.name));
    }
    skip(await events.next);
  }
}
