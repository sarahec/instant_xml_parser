import 'dart:async';

import 'package:async/async.dart';
import 'package:logging/logging.dart';
import 'package:xml/xml_events.dart';

extension TextValue on StreamQueue<XmlEvent> {
  static final _log = Logger('TextValue');

  /// Takes the current tag and scans for text events within it.
  ///
  /// Returns the text elements in the current tag joined by ```joinWith``` or
  /// ```null``` if not found;
  ///
  /// [joinWith] the join value between text fields.
  /// (optional, defaults to a single space)
  Future<String> textValue({joinWith = ' '}) async {
    var lines;
    var probe = await peek;
    if (probe is XmlStartElementEvent &&
        (probe as XmlStartElementEvent).isSelfClosing) return null;
    await withTransaction((queue) async {
      while (await queue.hasNext) {
        probe = await queue.next;
        if (probe is XmlTextEvent) {
          lines ??= [];
          var value = (probe as XmlTextEvent).text;
          lines.add(value);
          _log.finest('text: $value');
        } else if (probe is XmlEndElementEvent) {
          break;
        }
      }
      return lines != null;
    });
    return lines?.join(' ');
  }
}
