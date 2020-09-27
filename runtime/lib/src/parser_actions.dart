import 'package:logger/logger.dart';
import 'package:xml/xml_events.dart';

final logger = Logger(
  filter: null, // Use the default LogFilter (-> only log in debug mode)
  printer: PrettyPrinter(), // Use the PrettyPrinter to format and print log
  output: null, // Use the default LogOutput (-> send everything to console)
  level: Level.debug,
);

void skip(XmlEvent event) {
  if (event is XmlStartElementEvent) {
    logger.d('Skipped: START <${event.name}>');
  } else {
    logger.v('Skipped $event');
  }
}
