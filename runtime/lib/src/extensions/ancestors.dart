import 'package:xml/xml_events.dart';
import 'package:xml/src/xml_events/utils/parented.dart';

extension Ancestors on XmlParented {
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
