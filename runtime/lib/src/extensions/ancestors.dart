import 'package:xml/xml_events.dart';
import 'package:xml/src/xml_events/utils/parented.dart';

extension Ancestors on XmlParented {
  bool descendsFrom(ancestor) =>
      // can't use '.contains' since it depends on equality, so will return false
      // positives for two events of the same type without any attributes
      ancestor == null ? false : ancestors.any((e) => identical(e, ancestor));

  Iterable<XmlEvent> get ancestors sync* {
    var probe = parentEvent;
    while (probe != null) {
      yield probe;
      probe = probe?.parentEvent;
    }
  }
}
