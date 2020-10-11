library parse_generator;

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:runtime/annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'import_uris.dart';
import 'method.dart';
import 'method_info.dart';

class LibraryGenerator {
  final Iterable<MethodGenerator> methodEntries;
  final AssetId sourceAsset;

  LibraryGenerator.fromLibrary(LibraryReader library, this.sourceAsset)
      : methodEntries = library.annotatedWith(TypeChecker.fromRuntime(tag)).map(
            (e) =>
                MethodGenerator.fromElement(e.element, MethodInfo(e.element)));

  Class get classWrapper => Class((b) => b
    ..name = 'Parser' // BUGBUG Add name of source file, uing Pascal case
    ..fields.addAll(constants)
    ..methods.addAll(methods)
    ..methods.add(Method((b) => b
      ..name = '_pr'
      ..type = MethodType.getter
      ..lambda = true
      ..returns = Reference('ParserRuntime', ParserRuntime)
      ..body = Code('ParserRuntime()'))));

  Iterable<Field> get constants => methodEntries.map((c) => Field((b) => b
    ..name = c.info.constantName
    ..assignment = Code("'${c.info.tagName}'")
    ..static = true
    ..modifier = FieldModifier.constant));

  List<Method> get methods {
    final entries = methodEntries.map((c) => c.toMethod).toList();
    entries.sort((a, b) => a.name.compareTo(b.name));
    return entries;
  }

  Library get toCode => Library((b) => b
    ..directives.add(Directive.import(sourceAsset.pathSegments.last))
    ..body.add(classWrapper));

  String get toSource => DartEmitter().visitLibrary(toCode).toString();
}
