// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
import 'dart:async';

import 'package:async/async.dart';
import 'package:logging/logging.dart';
import 'package:xml/xml_events.dart';

import 'matcher.dart';

final _log = Logger('find:');

extension Find on StreamQueue<XmlEvent> {
  /// Scans the current queue for a match. Returns the found element or null.
  /// Leaves the queue untouched if not found.
  ///
  /// [match] Function that returns true when found.
  /// [keepFound] if true, keeps the found value at the start if the queue.
  Future<XmlEvent> find(Matcher match, {keepFound = false}) async {
    var probe;
    await withTransaction((queue) async {
      probe = await _find(match, queue);
      return probe != null;
    });
    if (probe != null && !keepFound && await hasNext) {
      await next; // drop from queue
    }
    return probe;
  }

  // Consume unmatched elements up until the found element. Returns the
  // found element or null.
  Future<XmlEvent> _find(Matcher match, StreamQueue<XmlEvent> queue) async {
    var probe;
    for (;;) {
      if (!await queue.hasNext) {
        return null as XmlEvent;
      }
      probe = await queue.peek;
      try {
        if (match(probe)) {
          return probe;
        }
      } catch (e) {
        _log.fine(e);
        return null as XmlEvent;
      }
      probe = await queue.next;
    }
  }
}
