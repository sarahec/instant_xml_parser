library runtime;

import 'dart:async';

import 'package:async/async.dart';
import 'package:logging/logging.dart';
import 'package:xml/xml_events.dart';

import 'converters.dart';
import 'errors.dart';

typedef ParseMethod<T> = Future<T> Function(StreamQueue<XmlEvent> events);

class ParserRuntime {
  final _log = Logger('ParserRuntime');

  /// Scans to the end of the starting tag, setting the event queue there.
  ///
  Future<bool> endOf(StreamQueue<XmlEvent> events,
      FutureOr<XmlStartElementEvent> startTag) async {
    if (startTag == null) return null;
    var element = await Future.value(startTag);
    if (element.isSelfClosing) {
      return true;
    }
    var transaction = events.startTransaction();
    var queue = transaction.newQueue();
    while (await queue.hasNext) {
      var probe = await queue.next;
      if (probe is XmlEndElementEvent &&
          probe.qualifiedName == element.qualifiedName) {
        transaction.commit(queue);
        return true;
      }
    }
    // Hit end of stream and found nothing
    transaction.reject();
    _log.warning('Could not find closing tag for <${element.name}>)');
    return false;
  }

  Future<void> logUnknown(
      FutureOr<XmlStartElementEvent> elementFuture, String parentName) async {
    var element = await Future.value(elementFuture);
    _log.fine(
        'Skipping unknown tag <${element.qualifiedName}> in <$parentName>');
  }

  Future<T> namedAttribute<T>(
      FutureOr<XmlStartElementEvent> elementFuture, String attributeName,
      {Converter<T> convert, isRequired = false, T defaultValue}) async {
    convert = convert ?? _autoConverter(T);
    assert(convert != null || T == String, 'converter required');

    final element = await Future.value(elementFuture);

    // if the name has a namespace, match exactly. If it doesn't,
    // try a namespace-free match
    final attribute = element.attributes.firstWhere(
        (a) =>
            (a.name == attributeName) ||
            (_stripNamespace(a.name) == attributeName),
        orElse: () => null);
    final value = attribute?.value;

    if (value == null) {
      if (isRequired) {
        return Future.error(MissingAttribute(element.name, attributeName));
      }
      // If we're returning the default value, we can bypass the converter
      return value ?? defaultValue;
    }

    return convert == null ? value : convert(value);
  }

  /// Scans ahead to the next XmlStartElementEvent, setting event queue
  /// to the found element or resetting it
  ///
  /// [events] Incoming event queue
  /// [parent] If supplied, returns only children of this node
  /// [name] If supplied, returns only nodes with this qualified name
  Future<XmlStartElementEvent> startOf(StreamQueue<XmlEvent> events,
      {String name,
      XmlStartElementEvent parent,
      failOnMismatch = false}) async {
    // Scan for a start tag
    var transaction = events.startTransaction();
    var queue = transaction.newQueue();

    while (await queue.hasNext) {
      var probe = await queue.peek;
      if (probe is XmlStartElementEvent) {
        if ((parent == null || probe.parentEvent == parent) &&
            (name == null || probe.qualifiedName == name)) {
          transaction.commit(queue);
          return probe;
        }
        if (failOnMismatch) {
          // found, no match, reject
          transaction.reject();
          _log.fine('Missing start tag <$name>, found <${probe.name}>');
          return Future.error(MissingStartTag(name, foundTag: probe.name));
        }
      }
      await queue.skip(1);
    }
    _log.finest('Reached end of stream looking for start tag');
    transaction.reject();
    return null;
  }

  String _stripNamespace(String s) => s.split(':').last;

  Future<String> textOf(
      StreamQueue<XmlEvent> events, XmlStartElementEvent startEvent) async {
    var lines;
    var probe = await events.peek;
    assert(probe == startEvent || probe.parentEvent == startEvent);
    assert(!startEvent.isSelfClosing);

    // Scan for text events
    var transaction = events.startTransaction();
    var queue = transaction.newQueue();
    while (await queue.hasNext) {
      probe = await queue.next;
      if (probe is XmlTextEvent) {
        lines ??= [];
        lines.add(probe.text);
      } else if (probe is XmlEndElementEvent) {
        break;
      }
    }
    if (lines == null) {
      _log.fine('No text found in <${startEvent.name}>');
    }
    transaction.reject(); // don't advance
    return lines?.join(' ');
  }

  Converter _autoConverter(Type T) => (T == bool)
      ? Convert.toBool
      : (T == int)
          ? Convert.toInt
          : (T == double)
              ? Convert.toDouble
              : null;
}
