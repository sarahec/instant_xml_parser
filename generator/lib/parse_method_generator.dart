import 'dart:async';

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:logging/logging.dart';
import 'package:source_gen/source_gen.dart';

import 'src/generators/library_gen.dart';

import 'package:dart_style/dart_style.dart';
import 'package:runtime/annotations.dart';

const asyncPackage = 'dart:async';

class ParseMethodGenerator extends Generator {
  final _log = Logger('ParseMethodGenerator');

  /// Build an overall symbol table before generating the individual items
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    final emitter = DartEmitter(Allocator());
    if (library.annotatedWithExact(TypeChecker.fromRuntime(tag)).isEmpty) {
      return '';
    }
    final gen = LibraryGenerator.fromLibrary(library, buildStep.inputId);
    var source = '${gen.toCode.accept(emitter)}';
    _log.finest(source);
    return DartFormatter().format(source);
  }
}
