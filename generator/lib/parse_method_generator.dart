import 'dart:async';

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/codegen.dart';

const asyncPackage = 'dart:async';

class ParseMethodGenerator extends Generator {
  /// Build an overall symbol table before generating the individual items
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async =>
      LibraryGenerator.fromLibrary(library).toSource;
}
