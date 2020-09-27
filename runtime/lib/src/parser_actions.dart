import 'package:xml/xml_events.dart';

import 'logging.dart';

void skip(XmlEvent event) {
  if (event is XmlStartElementEvent) {
    log.d('Skipped: START <${event.name}>');
  } else {
    log.v('Skipped $event');
  }
}
