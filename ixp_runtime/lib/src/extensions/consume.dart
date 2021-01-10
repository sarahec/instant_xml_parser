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
import 'package:async/async.dart';
import 'package:logging/logging.dart';
import 'package:xml/xml_events.dart';

import 'matcher.dart';

final _log = Logger('consume:');

extension Consume on StreamQueue<XmlEvent> {
  /// Skip all events while the matcher returns true.
  Future<void> consume(Matcher match) async {
    while (await hasNext) {
      final p = await peek;
      if (!match(p)) break;
      _log.finest(p);
      await next;
    }
  }
}
