import 'dart:async';

import 'package:async/async.dart';
import 'package:xml/xml_events.dart';

import 'logging.dart';
import 'parser_runtime.dart';

typedef ParseMethod<T> = Future<T> Function(StreamQueue<XmlEvent> events);

class ChildParser {
  final Map<String, ParseMethod> dispatchMap;
  final ParserRuntime pr;

  ChildParser(this.dispatchMap, this.pr);

  Iterable<String> get skippedChildren => _skipped;

  var _skipped;

  Future<Map<String, dynamic>> parseAll(StreamQueue<XmlEvent> events) async {
    Map<String, dynamic> results = {}; // ignore: omit_local_variable_types
    _skipped = <String>[];
    log.v('parsing children)');
    while (await events.hasNext) {
      var transaction = events.startTransaction();
      var queue = transaction.newQueue();
      await queue.skip(1); // Move off initial start tag
      var probe = await pr.startOf(queue);
      if (probe == null) {
        transaction.reject();
        return results;
      }
      var probeName = probe.qualifiedName;
      if (dispatchMap.containsKey(probeName)) {
        // TODO Deal with list results
        results[probeName] =
            await Function.apply(dispatchMap[probeName], [queue]);
      } else {
        _skipped.add(probeName);
      }
      transaction.commit(queue);
    }
  }
}
