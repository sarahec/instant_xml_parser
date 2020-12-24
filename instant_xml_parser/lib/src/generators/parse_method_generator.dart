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

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:instant_xml_parser/src/info/library_info.dart';
import 'package:logging/logging.dart';
import 'package:ixp_runtime/annotations.dart';
import 'package:source_gen/source_gen.dart';

import '../codegen/library_gen.dart';

/// Creates the parser by reading annotated Dart code.
///
/// Note: If buile_runner isn't returing an output, turn on extra-verbose
/// logging to see the generated code before it goes through the formatter:
/// ```sh
/// dart pub run build_runner build -vv
/// ```
class ParseMethodGenerator extends Generator {
  final _log = Logger('ParseMethodGenerator');
  final _tagChecker = TypeChecker.fromRuntime(tag);

  /// Reads a single Dart file and emits the matching parser. Called once per
  /// source file.
  ///
  /// Note this will only emit a parser if the file contains at least one
  /// class annotated with ```@tag```.
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    // skip files that lack the required annotation
    if (library.annotatedWithExact(_tagChecker).isEmpty) {
      return null;
    }
    final info = LibraryInfo.fromLibrary(library, buildStep.inputId);
    final libGen = LibraryGenerator(info, buildStep.inputId);
    final emitter = DartEmitter(Allocator());
    var source = '${libGen.toCode.accept(emitter)}';
    _log.finest(() => source);
    return DartFormatter().format(source);
  }
}
