import 'dart:async';

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:generator/src/info/library_info.dart';
import 'package:logging/logging.dart';
import 'package:runtime/annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'src/generators/library_gen.dart';

class ParseMethodGenerator extends Generator {
  final _log = Logger('ParseMethodGenerator');
  final _tagChecker = TypeChecker.fromRuntime(tag);

  /// Build an overall symbol table before generating the individual items
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    // skip files that lack the required annotation
    if (library.annotatedWithExact(_tagChecker).isEmpty) {
      return null;
    }
    final info = LibraryInfo.fromLibrary(library);
    final libGen = LibraryGenerator(info, buildStep.inputId);
    final emitter = DartEmitter(Allocator());
    var source = '${libGen.toCode.accept(emitter)}';
    _log.finest(source);
    return DartFormatter().format(source);
  }
}
