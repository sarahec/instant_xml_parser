import 'dart:async';

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart';

import 'src/generators/library.dart';

import 'package:dart_style/dart_style.dart';

const asyncPackage = 'dart:async';

class ParseMethodGenerator extends Generator {
  /// Build an overall symbol table before generating the individual items
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    final emitter = DartEmitter(Allocator());
    final gen = LibraryGenerator.fromLibrary(library, buildStep.inputId);
    return (gen.methods.isEmpty)
        ? '' // don't generate a file for this source
        : DartFormatter().format('${gen.toCode.accept(emitter)}');
  }
}
