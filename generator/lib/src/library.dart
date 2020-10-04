library parse_generator;

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:runtime/annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'common.dart';
import 'method.dart';

class LibraryGenerator {
  final Iterable<MethodGenerator> classEntries;
  final AssetId sourceAsset;

  LibraryGenerator.fromLibrary(LibraryReader library, this.sourceAsset)
      : classEntries = library
            .annotatedWith(TypeChecker.fromRuntime(Tag))
            .map((e) => MethodGenerator.fromElement(e.element));

  Class get classWrapper => Class((b) => b
    ..name = 'Parser' // BUGBUG Add name of source file, uing Pascal case
    ..fields.addAll(constants)
    ..methods.addAll(methods)
    ..methods.add(Method((b) => b
      ..name = 'pr'
      ..type = MethodType.getter
      ..lambda = true
      ..returns = Reference('ParserRuntime', ParserRuntime)
      ..body = Code('ParserRuntime()'))));

  Iterable<Field> get constants => classEntries.map((c) => Field((b) => b
    ..name = c.constantName
    ..assignment = Code("'${c.constantValue}'")
    ..modifier = FieldModifier.final$));

  List<Method> get methods => classEntries.map((c) => c.toMethod).toList();

  Library get toCode => Library((b) => b
    ..directives.add(Directive.import(sourceAsset.pathSegments.last))
    ..body.add(classWrapper));

  String get toSource => DartEmitter().visitLibrary(toCode).toString();
}
