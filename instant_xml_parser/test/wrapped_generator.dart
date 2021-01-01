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
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:instant_xml_parser/src/generators/parse_method_generator.dart';
import 'package:logging/logging.dart';
import 'package:source_gen/source_gen.dart';

// Test setup adapted from built_value (thank you, kevmoo@)

class WrappedGenerator {
  final String pkgName = 'pkg';

  final Builder builder = LibraryBuilder(ParseMethodGenerator(),
      generatedExtension: '.parser.dart');

  String error;
  List<String> warnings;

  Future<String> generate(String source) async {
    var srcs = <String, String>{
      'ixp_runtime|lib/annotations.dart': annotationsSource,
      '$pkgName|lib/structures.dart': source,
    };

    // Capture any error from generation; if there is one, return that instead of
    // the generated output.

    void captureError(LogRecord logRecord) {
      if (logRecord.error is InvalidGenerationSourceError) {
        if (error != null) throw StateError('Expected at most one error.');
        error = logRecord.error.toString();
      }
    }

    error = null;
    warnings = <String>[];
    var writer = InMemoryAssetWriter();
    await testBuilder(builder, srcs,
        rootPackage: pkgName, writer: writer, onLog: captureError);
    return error ??
        String.fromCharCodes(
            writer.assets[AssetId(pkgName, 'lib/structures.parser.dart')] ??
                []);
  }

  static const String annotationsSource = r'''
library annotations;
class tag {
  final String value;

  const tag(this.value);
}

const textElement = TextElement();

class TextElement {
  const TextElement();
}

class convert {
  final String source;

  const convert(this.source);
}

class custom {
  final String template;

  const custom(this.template);
}
''';
}
