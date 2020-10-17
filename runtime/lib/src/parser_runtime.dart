library runtime;

import 'dart:async';

import 'package:async/async.dart';
import 'package:logging/logging.dart';
import 'package:xml/xml_events.dart';

import 'converters.dart';
import 'errors.dart';

typedef ParseMethod<T> = Future<T> Function(StreamQueue<XmlEvent> events);

/// Contains utility methods for parsing a stream of XML events.
class ParserRuntime {
  final _log = Logger('ParserRuntime');

  /// Advances the event queue
  ///
  /// Advances the event queue by ```count``` events.
  /// Can be overridden if you need to do something else such as
  /// logging.
  ///
  /// [events] the event queue
  /// [count] number of events to skip
  void consume(StreamQueue<XmlEvent> events, int count) async =>
      events.skip(count);

  /// Scans to the end of the specified start tag.
  ///
  /// Returns true if the end of the tag exists.
  ///
  /// If the start tag is self-closing, returns ```true``` and
  /// advances to the next event.
  /// Otherwise, finds the corresponding end tag and sets the queue
  /// there. Returns ```true``` if found, else returns ```false```, leaves
  /// the event queue unchanged, and logs a warning.
  ///
  /// [events] The event queue
  /// [startTag] the current start tag
  Future<bool> endOf(StreamQueue<XmlEvent> events,
      FutureOr<XmlStartElementEvent> startTag) async {
    if (startTag == null) return null;
    var element = await Future.value(startTag);
    if (element.isSelfClosing) {
      // get off this start tag
      await consume(events, 1);
      return true;
    }
    // Scan for the end
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

  /// Utility to log an "unknown tag" message, typically called by generated
  /// parsers.
  ///
  /// [elementFuture] the found start element
  /// [parentName] the parent tag being parsed
  Future<void> logUnknown(
      FutureOr<XmlStartElementEvent> elementFuture, String parentName) async {
    var element = await Future.value(elementFuture);
    _log.fine(
        'Skipping unknown tag <${element.qualifiedName}> in <$parentName>');
  }

  /// Extracts an attribute from an element, converting it into a desired type.
  ///
  /// Looks for the named attribute on the supplied element, supplying a
  /// converter automatically if possible. Returns the value if found,
  /// ```null``` if not found, or throws ```Future.error``` if not found and
  /// marked as required.
  ///
  /// [T] the type to return
  /// [elementFuture] the start tag
  /// [attributeName] the name of the attribute to find. Accepts fully
  /// qualified or unqualified names.
  /// [convert] (optional) if supplied, applies a converter of the form
  /// ```T Function (String s)``` to the found value. If not supplied,
  /// calls ```autoConverter(T)``` to find a converter.
  /// [isRequired] (optional) if true, throws a ```Future.error``` if the
  /// attribute isn't found.
  /// [defaultValue] (optional) if supplied, a missing attribute will return
  /// this value instead.
  ///
  /// Typical call:
  /// ```final name = _pr.namedAttribute<String>(_startTag, 'name')```
  Future<T> namedAttribute<T>(
      FutureOr<XmlStartElementEvent> elementFuture, String attributeName,
      {Converter<T> convert, isRequired = false, T defaultValue}) async {
    convert = convert ?? autoConverter(T);
    assert(convert != null || T == String, 'converter required');

    final element = await Future.value(elementFuture);

    // if the name has a namespace, match exactly. If it doesn't,
    // try a namespace-free match
    final attribute = element.attributes.firstWhere(
        (a) =>
            (a.name == attributeName) ||
            (_stripNamespace(a.name) ==
                attributeName), // TODO: Disallow namespace stripping in strict mode
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

  /// Scans ahead to the next XmlStartElementEvent (with optional restrictions)
  ///
  /// Scans to the next XmlStartElement event, returning the event. Returns
  /// ```null``` if not found, unless ```parent``` and/or ```name``` are
  /// supplied, in which case throws ```Future.error```.
  ///
  /// If there is a matching event, sets the event queue there. Otherwise,
  /// leaves the event queue untouched.
  ///
  /// [events] incoming event queue
  /// [parent] (optional) if supplied, returns only children of this node
  /// [name] (optional) if supplied, returns only nodes with this qualified name
  /// [failOnMismatch] (optional) if true, throw ```Future.error``` if the next
  /// start tag found doesn't match expectations.
  ///
  /// Typical call:
  /// ```final _startTag = _pr.startOf(events, name: SomeTagName)```
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
      await consume(queue, 1);
    }
    _log.finest('Reached end of stream looking for start tag');
    transaction.reject();
    return null;
  }

  String _stripNamespace(String s) => s.split(':').last;

  /// Takes the current tag and scans for text events within it.
  ///
  /// Returns the text elements in the current tag joined by ```joinWith``` if
  /// found or returns; or ```null``` if the event is 1) self-closing or
  /// 2) contains no text.
  ///
  /// Advances the queue to the end tag if text is found, otherwise leaves it
  /// unchanged.
  ///
  /// [events] the current event stream, which should be pointing to:
  /// [startEvent] the start of an event
  /// [joinWith] (optional, defaults to a single space) the join value between
  /// text fields.
  Future<String> textOf(
      StreamQueue<XmlEvent> events, XmlStartElementEvent startEvent,
      {joinWith = ' '}) async {
    var lines;
    var probe = await events.peek;
    assert(probe == startEvent || probe.parentEvent == startEvent);
    if (startEvent.isSelfClosing) return null;

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

  /// Returns a converter from String to the specified built-in type.
  ///
  /// May be overriden in a subclass to add new converter types,
  /// but TODO: use the ```@converter``` tag for a better approach.
  Converter autoConverter(Type T) => (T == bool)
      ? Convert.toBool
      : (T == int)
          ? Convert.toInt
          : (T == double)
              ? Convert.toDouble
              : null;
}
