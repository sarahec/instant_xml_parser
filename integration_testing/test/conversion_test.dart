import 'package:test/test.dart';
import 'package:ixp_runtime/ixp_runtime.dart';
import 'package:testing/conversion.parser.dart';

// Copyright 2021 Google LLC
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

const EXAMPLE = 'https://example.com';

void main() {
  test('text body', () async {
    final location = await extractLocation(
        generateEventStream(Stream.value('<loc>$EXAMPLE</loc>')));
    expect(location.loc, equals(Uri.parse(EXAMPLE)));
  });

  test('body and attribute', () async {
    final location = await extractLocation(generateEventStream(
        Stream.value('<loc testUri="$EXAMPLE">$EXAMPLE</loc>')));
    expect(location.loc, equals(Uri.parse(EXAMPLE)));
    expect(location.testUri, equals(Uri.parse(EXAMPLE)));
  });

  test(
      'value missing',
      () async => expect(
          extractLocation(generateEventStream(Stream.value('<loc></loc>'))),
          throwsA(const TypeMatcher<MissingText>())));
}
