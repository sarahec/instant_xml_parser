import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'package:docx_extractor/annotations.dart';

class ParseMethodGenerator extends GeneratorForAnnotation<FromXML> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    // 9:30
    return _generateParserMethod(element);
  }

  String _generateParserMethod(Element element) {
    var visitor = StructVisitor();
    element.visitChildren(visitor);
    return '// Found ${visitor.className}';
  }
}

class StructVisitor extends SimpleElementVisitor<void> {
  DartType className;

  @override
  void visitConstructorElement(ConstructorElement element) {
    {
      assert(className == null);
      className = element.type.returnType;
    }
  }
}
