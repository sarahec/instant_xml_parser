import 'dart:async';

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart';

import 'src/library.dart';

import 'package:logger/logger.dart';
import 'package:dart_style/dart_style.dart';

final log = Logger(
    filter: null, // Use the default LogFilter (-> only log in debug mode)
    printer: PrettyPrinter(), // Use the PrettyPrinter to format and print log
    output: null, // Use the default LogOutput (-> send everything to console)
    level: Level.debug);

const asyncPackage = 'dart:async';

class ParseMethodGenerator extends Generator {
  /// Build an overall symbol table before generating the individual items
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    final emitter = DartEmitter(Allocator());
    final gen = LibraryGenerator.fromLibrary(library, buildStep.inputId);
    return (gen.methodEntries.isEmpty)
        ? '' // don't generate a file for this source
        : DartFormatter().format('${gen.toCode.accept(emitter)}');
  }
}
