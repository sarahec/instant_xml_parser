/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
library parse_generator;

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:generator/src/import_uris.dart';
import 'package:generator/src/info/library_info.dart';
import 'package:generator/src/info/symtable.dart';

import 'method_gen.dart';

class LibraryGenerator {
  final LibraryInfo info;
  final AssetId sourceAsset;
  final Symtable symtable;

  var _importUris;

  LibraryGenerator(this.info, this.sourceAsset)
      : symtable = Symtable.fromLibraryInfo(info);

  Iterable<Method> get methods => [
        for (var method in symtable.methods)
          MethodGenerator(method, symtable).toMethod
      ];

  Iterable<String> get importUris {
    if (_importUris == null) {
      _importUris = <String>[];
      _importUris.add(sourceAsset.pathSegments.last);
      _importUris.addAll(info.importUris.where((s) =>
          !(s.contains('runtime/annotations.dart') || s.contains('/src/'))));
      _importUris.addAll([Logging, Runtime]);
    }
    return _importUris;
  }

  Iterable<Field> get constants => symtable.methods.map((c) => Field((b) => b
    ..name = c.classInfo.constantName
    ..assignment = Code("'${c.classInfo.tagName}'")
    ..modifier = FieldModifier.constant));

  Library get toCode => Library((b) => b
    ..directives.addAll(importUris.map((i) => Directive.import(i)))
    ..body.addAll(constants)
    ..body.add(Code("final _log = Logger('parser');"))
    ..body.addAll(methods));
}
