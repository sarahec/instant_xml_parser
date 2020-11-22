import 'package:logging/logging.dart';
import 'package:xml/xml_events.dart';

extension Logging on XmlStartElementEvent {
  static final _log = Logger('unknown: ');

  /// Utility to log an "unknown tag" message, typically called by generated
  /// parsers.
  ///
  /// [expected] the expected tag's name
  void logUnknown({expected = '(any)'}) =>
      _log.fine('skipping $qualifiedName in $parentEvent, expected $expected');
}
