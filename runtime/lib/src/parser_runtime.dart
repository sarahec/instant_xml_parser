import 'dart:async';

import 'package:async/async.dart';
import 'package:meta/meta.dart';
import 'package:xml/xml_events.dart';

import 'converters.dart';
import 'errors.dart';
import 'logging.dart';

class ParserRuntime {
  /// Scans ahead to the next XmlStartElementEvent, setting event queue
  /// to the found element or resetting it
  ///
  /// [events] Incoming event queue
  /// [parent] If supplied, returns only children of this node
  /// [name] If supplied, returns only nodes with this qualified name
  Future<XmlStartElementEvent> startOf(StreamQueue<XmlEvent> events,
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
  Future<bool> endOf(FutureOr<XmlStartElementEvent> startTag,
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

  Future<T> namedAttribute<T>(
      FutureOr<XmlStartElementEvent> elementFuture, String attributeName,
      {Converter<T> convert, isRequired = false, T defaultValue}) async {
    assert(convert != null || !(T is String),
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

  void reportUnknownChild(XmlStartElementEvent child,
      {@required XmlStartElementEvent parent, shouldThrow = false}) {
    log.w('Unknown child <${child.name} inside <${parent.name}>');
    if (shouldThrow) {
      throw (UnexpectedChild(child.name));
    }
  }
}
