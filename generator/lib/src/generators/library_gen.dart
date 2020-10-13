library parse_generator;

import 'package:code_builder/code_builder.dart';
import 'package:generator/src/info/library_info.dart';
import 'package:source_gen/source_gen.dart';

import '../import_uris.dart';
import 'method_gen.dart';

class LibraryGenerator {
  final LibraryInfo library;

  // final Iterable<MethodGenerator> methodEntries;

  LibraryGenerator.fromLibrary(LibraryReader library, sourceAsset)
      : library = LibraryInfo.fromReader(library, sourceAsset);

  Class get classWrapper => Class((b) => b
    ..name = 'Parser' // TODO: Add name of source file, using Pascal case
    ..fields.addAll(constants)
    ..methods.addAll(methods)
    ..methods.add(runtimeGetter)
    ..methods.add(streamUtility));

  Method get runtimeGetter => Method((b) => b
    ..name = '_pr'
    ..type = MethodType.getter
    ..lambda = true
    ..returns = Reference('ParserRuntime', ParserRuntime)
    ..body = Code('ParserRuntime()'));

  Method get streamUtility => Method((b) => b
    ..name = 'generateEventStream'
    ..returns = Reference('StreamQueue<XmlEvent>')
    ..requiredParameters.add(Parameter((b) => b
      ..name = 'source'
      ..type = Reference('Stream<String>')))
    ..lambda = true
    ..body = Code('''StreamQueue(source
        .toXmlEvents()
        .withParentEvents()
        .normalizeEvents()
        .flatten())'''));

  Iterable<Method> get methods => [
        for (var method in library.symtable.methods)
          MethodGenerator(method, library.symtable).toMethod
      ];

  Iterable<Field> get constants =>
      library.symtable.methods.map((c) => Field((b) => b
        ..name = c.classInfo.constantName
        ..assignment = Code("'${c.classInfo.tagName}'")
        ..static = true
        ..modifier = FieldModifier.constant));

  Library get toCode => Library((b) => b
    ..directives.add(Directive.import(library.sourceAsset.pathSegments.last))
    ..body.add(classWrapper));

  String get toSource => DartEmitter().visitLibrary(toCode).toString();
}
