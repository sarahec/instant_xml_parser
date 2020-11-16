import 'dart:async';

import 'package:async/async.dart';
import 'package:logging/logging.dart';
import 'package:xml/xml_events.dart';

import '../errors.dart';
import 'ancestors.dart';

extension ParseUtils on StreamQueue<XmlEvent> {
  static final _log = Logger('ParseUtils');

  Future<XmlStartElementEvent> start(
      {String name, XmlEvent after, throwsOnError = true}) async {
    final ok = await withTransaction((queue) async {
      if (after != null && await queue.peek == after) {
        await queue.take(1);
      }
      while (await queue.hasNext) {
        var probe = await queue.peek;
        if (probe is XmlStartElementEvent &&
            (name == null || probe.qualifiedName == name)) {
          return true;
        }
        probe = await queue.next;
      }
      _log.finest('Start tag $name not found');
      return false;
    });
    return ok
        ? await peek as XmlStartElementEvent
        : throwsOnError
            ? Future.error(MissingStartTag(name))
            : null;
  }

  Future<bool> inside(XmlStartElementEvent tag) async {
    var probe = await peek;
    return probe == tag || probe.descendsFrom(tag);
  }

  Future<bool> atEnd(XmlStartElementEvent tag) async {
    var probe = await peek;
    return (probe == null ||
        tag.isSelfClosing ||
        (probe is XmlEndElementEvent &&
            probe.qualifiedName == tag.qualifiedName) ||
        !probe.descendsFrom(tag)); // in case we've moved off the end of the tag
  }

  /// Scans to the end of the specified start tag.
  ///
  /// Leaves the next tag at the top of the queue.
  /// [tag] the current start tag
  Future<bool> end(XmlStartElementEvent tag, {throwsOnError = true}) async {
    return withTransaction((queue) async {
      while (await queue.hasNext) {
        if (await queue.atEnd(tag)) {
          return true;
        }
        await queue.next;
      }
      final error = '</${tag.qualifiedName}>} not found';
      _log.finest(error);

      return throwsOnError
          ? Future.error(MissingEndTag(tag.qualifiedName))
          : false;
      ;
    });
  }
}
