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
library parse_generator;

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:instant_xml_parser/ixp_core.dart';
import 'package:instant_xml_parser/src/import_uris.dart';
import 'package:logging/logging.dart';
import 'package:source_gen/source_gen.dart';

/// Emits one parser file.

class LibraryGenerator {
  static final _log = Logger('LibraryGenerator');

  /// The result of parsing the source file.
  final LibraryReader sourceInfo;

  /// Name, location, etc. of the source file (needed to import that into
  /// its parser)
  final AssetId sourceAsset;
  final bool nullSafe;

  /// The source for all import statements
  late final Iterable<String> importUris = <String>[
    sourceAsset.pathSegments.last,
    ...sourceInfo.importUris.where((s) =>
        !(s.contains('runtime/annotations.dart') || s.contains('/src/'))),
    Logging,
    Runtime
  ];

  LibraryGenerator(this.sourceInfo, this.sourceAsset, this.nullSafe);

  /// Get the source for the tag name constands
  Iterable<Field> get constants =>
      sourceInfo.classesForParser.map((c) => Field((b) => b
        ..name = c.constantName
        ..assignment = Code("'${c.tagName}'")
        ..modifier = FieldModifier.constant));

  /// Get the source for all methods
  Iterable<Method> get methods => [
        for (var method in sourceInfo.classesForParser)
          MethodGenerator(method, sourceInfo).toMethod
      ];

  /// Assemble everything into a finished file
  Library get toCode {
    _log.fine('''
    
    ---------------------------------------------------------------------------
    Generating for source: ${sourceAsset.uri}
    ''');
    final result = Library((b) => b
      ..directives.addAll(importUris.map((i) => Directive.import(i)))
      ..body.addAll(constants)
      ..body.add(Code("final _log = Logger('parser');"))
      ..body.addAll(methods));
    return result;
  }
}
