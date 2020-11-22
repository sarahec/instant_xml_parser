import 'package:async/async.dart';
import 'package:logging/logging.dart';
import 'package:xml/xml_events.dart';

import 'matcher.dart';

final _log = Logger('consume:');

extension Consume on StreamQueue<XmlEvent> {
  void consume(Matcher matching) async {
    while (await hasNext && matching(await peek)) {
      var p = await peek;
      if (p == null) break;
      _log.finest(p);
      await next;
    }
  }
}
