import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:parse_tools/annotations.dart';
import 'package:recase/recase.dart';
import 'package:source_gen/source_gen.dart';

const asyncPackage = 'dart:async';

class ParseMethodGenerator extends GeneratorForAnnotation<FromXML> {
  final formatter = DartFormatter();

  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    final info = _StructVisitor();
    final tag = tagOf(annotation);
    element.visitChildren(info);
    var method = _method(info.className, tag, info.fields);
    return formatter.format(method);
  }

  String tagOf(annotation) => annotation.read('tag').literalValue as String;

  String _method(className, tag, fields) {
    // final vars = fields.map((f) => 'var ${f.name};').join();
    var methodName = ReCase(className).camelCase;
    return '''
      FutureOr<$className> $methodName(StreamQueue<XmlEvent> events) async {
        const tag = '$tag';
        // <<< Other field declarations
        if (!(await hasStartTag(events, withName: tag))) {
          return Future.error('Expected <$tag> at start');
        }
        var startTag = await events.next;
        // Extract any attributes you need from this tag

        while (await hasChildOf(events, startTag)) {
          var probe = await events.next;
          print(probe);
          // <<< gather fields
        }

        return $className();
      }''';
  }
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
