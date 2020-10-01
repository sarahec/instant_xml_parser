import 'dart:async';

import 'package:async/async.dart';
import 'package:meta/meta.dart';
import 'package:xml/xml_events.dart';

import 'converters.dart';
import 'errors.dart';
import 'logging.dart';

typedef ParseMethod<T> = Future<T> Function(StreamQueue<XmlEvent> events);

abstract class ExtractorAction<T> {
  String get key; // result identifier

  Future<T> execute(StreamQueue<XmlEvent> events, ParserRuntime pr,
      {T priorValue});
}

class GetAttr<T> implements ExtractorAction<T> {
  final String attrName;
  final bool isRequired;
  final T defaultValue;
  final Converter convert;

  GetAttr(this.attrName,
      {this.isRequired = false, this.defaultValue, this.convert});

  @override
  Future<T> execute(StreamQueue<XmlEvent> queue, ParserRuntime pr,
      {T priorValue}) async {
    var startTag = await queue.peek;
    return (startTag is XmlStartElementEvent)
        ? pr._namedAttribute<T>(startTag, attrName,
            defaultValue: defaultValue,
            isRequired: isRequired,
            convert: convert ?? _autoConverter)
        : Future.error(MissingStartTag(key));
  }

  Converter get _autoConverter => (T == bool)
      ? Convert.toBool
      : (T == int) ? Convert.toInt : (T == double) ? Convert.toDouble : null;

  @override
  String get key => attrName;
}

class GetTag<T> implements ExtractorAction<T> {
  final String tagName;
  final ParseMethod<T> method;

  GetTag(this.tagName, this.method);

  @override
  String get key => tagName;

  @override
  Future<T> execute(StreamQueue<XmlEvent> queue, ParserRuntime pr,
      {T priorValue}) async {
    if (T is List) {
      // We have to type this so .add will work (Dart 2.9.3)
      List returnValue = priorValue ?? []; // ignore: omit_local_variable_types
      returnValue.add(Function.apply(method, [queue]));
      return returnValue as T;
    }
    return Function.apply(method, [queue]);
  }
}

class ParserRuntime {
  Future<Map<String, dynamic>> parse(StreamQueue<XmlEvent> events,
      String tagName, Iterable<ExtractorAction> actions) async {
    Map<String, dynamic> results = {}; // ignore: omit_local_variable_types
    if (!await events.hasNext) {
      return Future.error(EndOfQueue());
    }

    final transaction = events.startTransaction();
    final queue = transaction.newQueue();
    final startTag = await _startOf(queue, name: tagName, mustBeFirst: true);
    if (startTag == null) {
      transaction.reject();
      return Future.error(MissingStartTag(tagName));
    }
    for (var action in actions) {
      var key = action.key;
      results[key] =
          await action.execute(queue, this, priorValue: results[key]);
    }
    await _endOf(startTag, queue);
    transaction.commit(queue);
    return results;
  }

  /// Scans ahead to the next XmlStartElementEvent, setting event queue
  /// to the found element or resetting it
  ///
  /// [events] Incoming event queue
  /// [parent] If supplied, returns only children of this node
  /// [name] If supplied, returns only nodes with this qualified name
  Future<XmlStartElementEvent> _startOf(StreamQueue<XmlEvent> events,
      {String name, XmlStartElementEvent parent, mustBeFirst = false}) async {
    // Scan for a start tag
    var transaction = events.startTransaction();
    var queue = transaction.newQueue();
    while (await queue.hasNext) {
      var probe = await queue.peek;
      if (probe is XmlStartElementEvent) {
        if ((parent == null || probe.parentEvent == parent) &&
            (name == null || probe.qualifiedName == name)) {
          transaction.commit(queue);
          log.v('Found start of $probe');
          return probe;
        } else if (mustBeFirst) {
          // found, no match, reject
          transaction.reject();
          return Future.error(MissingStartTag(name, foundTag: probe.name));
        }
      }
      await queue.skip(1);
    }
    log.v('Reached end of stream looking for start tag');
    transaction.reject();
    return null;
  }

  /// Scans to the end of the starting tag, setting the event queue there.
  ///
  Future<bool> _endOf(FutureOr<XmlStartElementEvent> startTag,
      StreamQueue<XmlEvent> events) async {
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
    log.e('Could not find closing tag for <${element.name}>)');
    return false;
  }

  Future<T> _namedAttribute<T>(
      FutureOr<XmlStartElementEvent> elementFuture, String attributeName,
      {Converter<T> convert, isRequired = false, T defaultValue}) async {
    assert(convert != null || T == String,
        'converter required for non-String attributes');

    final element = await Future.value(elementFuture);

    final attribute = element.attributes
        .firstWhere((a) => a.name == attributeName, orElse: () => null);
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

  void _reportUnknownChild(XmlStartElementEvent child,
      {@required XmlStartElementEvent parent, shouldThrow = false}) {
    log.w('Unknown child <${child.name} inside <${parent.name}>');
    if (shouldThrow) {
      throw (UnexpectedChild(child.name));
    }
  }
}
