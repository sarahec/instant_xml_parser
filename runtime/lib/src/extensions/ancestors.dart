import 'package:xml/xml_events.dart';

extension Ancestors on XmlEvent {
  bool descendsFrom(ancestor) =>
      ancestor == null ? false : ancestors.contains(ancestor);

  Iterable<XmlEvent> get ancestors sync* {
    var probe = parentEvent;
    while (probe != null) {
      yield probe;
      probe = probe?.parentEvent;
    }
  }
}
