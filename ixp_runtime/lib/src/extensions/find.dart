// Copyright 2020, 2024 Google LLC and contributors
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

final _log = Logger('scanTo:');

extension Find on StreamQueue<XmlEvent> {
  /// Scan the current queue for a match, reverting the queue if not found.
  ///
  /// If found, the first element is the match.
  /// Leaves the queue untouched if not found.
  ///
  /// [match] Function that returns true when found.
  Future<bool> scanTo(Matcher match) async {
    return withTransaction((queue) async {
      while (await queue.hasNext) {
        try {
          if (match(await queue.peek)) return true;
        } catch (e) {
          _log.fine(e);
          return false;
        }
        await queue.next;
      }
      return false;
    });
  }
}
