library parse_generator;

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:generator/src/info/symtable.dart';

import 'method_gen.dart';

class LibraryGenerator {
  final AssetId sourceAsset;
  final Symtable symtable;

  // final Iterable<MethodGenerator> methodEntries;

  LibraryGenerator(this.symtable, this.sourceAsset);

  Iterable<Method> get methods => [
        for (var method in symtable.methods)
          MethodGenerator(method, symtable).toMethod
      ];

  Iterable<Field> get constants => symtable.methods.map((c) => Field((b) => b
    ..name = c.classInfo.constantName
    ..assignment = Code("'${c.classInfo.tagName}'")
    ..modifier = FieldModifier.constant));

  Library get toCode => Library((b) => b
    ..directives.add(Directive.import(sourceAsset.pathSegments.last))
    ..body.addAll(constants)
    ..body.addAll(methods));

  // String get toSource => DartEmitter().visitLibrary(toCode).toString();
}
