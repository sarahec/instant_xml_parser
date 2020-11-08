import 'dart:async';

import 'package:async/async.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:xml/xml_events.dart';
import 'start_element_extension.dart';

extension EndOfTag on StreamQueue<XmlEvent> {
  static final _log = Logger('EndOfTag');

  Future<bool> atEnd(XmlStartElementEvent tag) async {
    var probe = await peek;
    return tag.isSelfClosing ||
        (probe is XmlEndElementEvent &&
            probe.qualifiedName == tag.qualifiedName);
  }

  /// Scans to the end of the specified start tag.
  ///
  /// Leaves the next tag at the top of the queue.
  /// [tag] the current start tag
  Future<void> endOf(XmlStartElementEvent tag) async {
    if (tag.isSelfClosing) return;

    // Have we already moved off the end?
    var probe = await peek;
    if (probe is XmlStartElementEvent && !probe.descendsFrom(tag)) {
      return probe;
    }

    // Scan for the end
    var transaction = startTransaction();
    var queue = transaction.newQueue();
    while (await queue.hasNext) {
      var probe = await queue.next;
      if (probe is XmlEndElementEvent &&
          probe.qualifiedName == tag.qualifiedName) {
        transaction.commit(queue);
        return;
      }
    }

    // Hit end of stream and found nothing
    transaction.reject();
    _log.warning('Could not find closing tag for <${tag.name}>)');
  }

  @visibleForTesting
  bool descendsFrom(element, ancestor) =>
      ancestor == null ? false : ancestors(element).contains(ancestor);

  Iterable<XmlStartElementEvent> ancestors(element) sync* {
    var probe = element?.parentEvent;
    while (probe != null) {
      yield probe;
      probe = probe?.parentEvent;
    }
  }

  /// Takes the current tag and scans for text events within it.
  ///
  /// Returns the text elements in the current tag joined by ```joinWith``` or
  /// ```null``` if not found;
  ///
  /// [joinWith] (optional, defaults to a single space) the join value between
  /// text fields.
  Future<String> textValue({joinWith = ' '}) async {
    var lines;
    var probe = await peek;
    if (probe is XmlStartElementEvent && probe.isSelfClosing) return null;

    // Scan for text events
    var transaction = startTransaction();
    var queue = transaction.newQueue();
    while (await queue.hasNext) {
      probe = await queue.next;
      if (probe is XmlTextEvent) {
        lines ??= [];
        lines.add(probe.text);
      } else if (probe is XmlStartElementEvent || probe is XmlEndElementEvent) {
        break;
      }
    }
    if (lines == null) {
      _log.fine('No text found');
    }
    transaction.reject(); // don't advance
    return lines?.join(' ');
  }

  Future<XmlStartElementEvent> nextStart({XmlStartElementEvent inside}) async {
    if (!await hasNext) return null;
    var probe = await peek;
    if (probe is XmlStartElementEvent &&
        (inside == null || probe.parentEvent == inside)) {
      return probe;
    } else {
      final transaction = startTransaction();
      final queue = transaction.newQueue();
      while (await queue.hasNext) {
        probe = await next;
        if (probe is XmlStartElementEvent) {
          if (inside != null && !probe.descendsFrom(inside)) {
            break; // reject
          } else {
            transaction.commit(queue);
            return probe;
          }
        }
      }
      // Hit end of queue
      transaction.reject();
      return null;
    }
  }
}
