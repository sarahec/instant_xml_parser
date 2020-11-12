import 'package:logging/logging.dart';
import 'package:xml/xml_events.dart';

extension Logging on XmlStartElementEvent {
  static final _log = Logger('ElementExtensions');

  /// Utility to log an "unknown tag" message, typically called by generated
  /// parsers.
  ///
  /// [elementFuture] the found start element
  /// [parentName] the parent tag being parsed
  void logUnknown({expected = '(any)'}) => _log.fine(
      'Skipping unknown tag <${qualifiedName}> in <$parentEvent>, expected $expected');
}
