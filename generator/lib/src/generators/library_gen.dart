library parse_generator;

import 'package:code_builder/code_builder.dart';
import 'package:generator/src/info/library_info.dart';
import 'package:source_gen/source_gen.dart';

import 'method_gen.dart';

class LibraryGenerator {
  final LibraryInfo library;

  // final Iterable<MethodGenerator> methodEntries;

  LibraryGenerator.fromLibrary(LibraryReader library, sourceAsset)
      : library = LibraryInfo.fromReader(library, sourceAsset);

  Iterable<Method> get methods => [
        for (var method in library.symtable.methods)
          MethodGenerator(method, library.symtable).toMethod
      ];

  Iterable<Field> get constants =>
      library.symtable.methods.map((c) => Field((b) => b
        ..name = c.classInfo.constantName
        ..assignment = Code("'${c.classInfo.tagName}'")
        ..modifier = FieldModifier.constant));

  Library get toCode => Library((b) => b
    ..directives.add(Directive.import(library.sourceAsset.pathSegments.last))
    ..body.addAll(constants)
    ..body.addAll(methods));

  // String get toSource => DartEmitter().visitLibrary(toCode).toString();
}
