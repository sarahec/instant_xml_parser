import 'dart:async';

import 'package:async/async.dart';
import 'package:logging/logging.dart';
import 'package:xml/xml_events.dart';

import 'matcher.dart';

final _log = Logger('find:');

extension Find on StreamQueue<XmlEvent> {
  /// Scans the current queue for a match. Returns the found element or null.
  /// Leaves the queue untouched if not found.
  ///
  /// [match] Function that returns true when found.
  /// [keepFound] if true, keeps the found value at the start if the queue.
  Future<XmlEvent> findInTransaction(Matcher match, {keepFound = false}) async {
    var probe;
    await withTransaction((queue) async {
      probe = await _find(match, queue);
      return probe != null;
    });
    if (probe != null && !keepFound && await hasNext) {
      await next; // drop from queue
    }
    return probe;
  }

  Future<XmlEvent> find(Matcher match, {keepFound = false}) async {
    final probe = await _find(match, this);
    if (probe != null && !keepFound && await hasNext) {
      await next; // drop from queue
    }
    return probe;
  }

  Future<XmlEvent> _find(Matcher match, StreamQueue<XmlEvent> queue) async {
    var probe;
    for (;;) {
      if (!await queue.hasNext) {
        return null;
      }
      probe = await queue.peek;
      try {
        if (match(probe)) {
          return probe;
        }
      } catch (e) {
        _log.fine(e);
        return null;
      }
      probe = await queue.next;
    }
  }
}
