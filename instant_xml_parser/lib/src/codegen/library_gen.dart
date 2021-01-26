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
library parse_generator;

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:instant_xml_parser/src/import_uris.dart';
import 'package:instant_xml_parser/src/info/source_info.dart';

import 'method_gen.dart';

/// Emits one parser file.

class LibraryGenerator {
  /// The result of parsing the source file.
  final SourceInfo sourceInfo;

  /// Name, location, etc. of the source file (needed to import that into
  /// its parser)
  final AssetId sourceAsset;

  var _importUris;

  LibraryGenerator(this.sourceInfo, this.sourceAsset);

  /// Get the source for all methods
  Iterable<Method> get methods => [
        for (var method in sourceInfo.methods)
          MethodGenerator(method, sourceInfo).toMethod
      ];

  /// Get the source for all import statements
  Iterable<String> get importUris {
    if (_importUris == null) {
      _importUris = <String>[];
      _importUris.add(sourceAsset.pathSegments.last);
      _importUris.addAll(sourceInfo.importUris.where((s) =>
          !(s.contains('runtime/annotations.dart') || s.contains('/src/'))));
      _importUris.addAll([Logging, Runtime]);
    }
    return _importUris;
  }

  /// Get the source for the tag name constands
  Iterable<Field> get constants => sourceInfo.methods.map((c) => Field((b) => b
    ..name = c.classInfo.constantName
    ..assignment = Code("'${c.classInfo.tagName}'")
    ..modifier = FieldModifier.constant));

  /// Assemble everything into a finished file
  Library get toCode => Library((b) => b
    ..directives.addAll(importUris.map((i) => Directive.import(i)))
    ..body.addAll(constants)
    ..body.add(Code("final _log = Logger('parser');"))
    ..body.addAll(methods));
}
