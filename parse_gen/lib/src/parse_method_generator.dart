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
    var method = _method(info.className, tag, element);
    return formatter.format(method);
  }

  String tagOf(annotation) => annotation.read('tag').literalValue as String;

  String _method(className, tag, element) {
    final methodName = ReCase(className).camelCase;
    final fieldNames = element.fields.map((f) => f.name);
    final varDeclarations = _varDeclarations(element);
    final constructorValues = fieldNames.join(',');
    final fieldsFromAttributes = _assignFieldsFromAttributes(element);
    return '''
      FutureOr<$className> $methodName(StreamQueue<XmlEvent> events) async {
        const tag = '$tag';
        $varDeclarations
        if (!(await hasStartTag(events, withName: tag))) {
          return Future.error('Expected <$tag> at start');
        }
        var startTag = await events.next;
        $fieldsFromAttributes

        while (await hasChildOf(events, startTag)) {
          var probe = await events.next;
          print(probe);
          // <<< gather fields
        }

        return $className($constructorValues);
      }''';
  }
}

String _varDeclarations(element) =>
    element.fields.map((f) => 'var ${f.name};').join();

String _assignFieldsFromAttributes(element) {
  return element.fields.map((FieldElement f) {
    var name = f.name;
    var fieldType = f.type;
    if (fieldType.isDartCoreString) {
      return "$name = namedAttribute(startTag, '$name');";
    } else if (fieldType.isDartCoreInt) {
      return "$name = namedAttribute(startTag, '$name', (s) => int.parse(s));";
    } else if (fieldType.isDartCoreDouble) {
      return "$name = namedAttribute(startTag, '$name', (s) => double.parse(s));";
    } else if (fieldType.isDartCoreBool) {
      return "$name = namedAttribute(startTag, '$name', (s) => s == '1' || s == 'true');";
    } else {
      throw ("Cannot support attribute type '$fieldType' on '$name'");
    }
  }).join();
}

class _StructVisitor extends SimpleElementVisitor<void> {
  String className;

  @override
  void visitConstructorElement(ConstructorElement element) {
    {
      assert(className == null);
      className = element.type.returnType.toString();
    }
  }
}
