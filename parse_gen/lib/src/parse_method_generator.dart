import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:docx_extractor/annotations.dart';
import 'package:recase/recase.dart';
import 'package:source_gen/source_gen.dart';

class ParseMethodGenerator extends GeneratorForAnnotation<FromXML> {
  final emitter = DartEmitter(Allocator.simplePrefixing());
  final formatter = DartFormatter();

  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    final info = _StructVisitor();
    final tag = tagOf(annotation);
    print(tag); // <<<
    element.visitChildren(info);
    var method = _method(info.className, tag, info.fields);
    var code = method.accept(emitter).toString();
    return formatter.format(code);
  }

  String tagOf(annotation) => annotation.read('tag').literalValue as String;

  Method _method(className, tag, fields) {
    final vars = fields.map((f) => 'var ${f.name};').join();
    return Method((b) => b
      ..name = ReCase(className).camelCase
      ..returns = refer(className)
      ..body = _constructor(className).returned.statement);
  }

  Expression _constructor(className) => refer(className).newInstance([]);
}

class _StructVisitor extends SimpleElementVisitor<void> {
  String className;
  List<FieldElement> fields = [];

  @override
  void visitConstructorElement(ConstructorElement element) {
    {
      assert(className == null);
      className = element.type.returnType.toString();
    }
  }

  @override
  void visitFieldElement(FieldElement element) {
    fields.add(element);
  }
}
