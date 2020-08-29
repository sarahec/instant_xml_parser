import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:xml/xml_events.dart';

import 'elements.dart';

class Parser {
  @visibleForTesting
  FutureOr<TextRun> extractTextRun(Stream<XmlEvent> stream) async {
    var content;
    var capture;
    await for (var event in stream) {
      if (event is XmlStartElementEvent &&
          event.name == TextRun.qualifiedName) {
        // Initialize
        capture = false;
        content = <String>[];
      } else if (event is XmlStartElementEvent && event.name == 'w:t') {
        capture = true;
      } else if (event is XmlEndElementEvent && event.name == 'w:t') {
        capture = false;
      } else if (capture && event is XmlTextEvent) {
        content.add(event.text);
      } else if (event is XmlEndElementEvent &&
          event.name == TextRun.qualifiedName) {
        break;
      }
    }
    return TextRun(
        content == null ? '' : content.map((s) => s.trim()).join(' '));
  }

  Stream<List<XmlEvent>> generateEventStream({String xml, File file}) {
    var source = (xml != null)
        ? Stream.value(xml)
        : file.openRead().transform(utf8.decoder);
    return source.toXmlEvents().normalizeEvents();
  }
}
