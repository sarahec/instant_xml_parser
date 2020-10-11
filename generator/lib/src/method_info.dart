import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:recase/recase.dart';
import 'package:runtime/annotations.dart';

import 'annotation_reader.dart';

class MethodInfo {
  final String tagName;
  final String prefix;
  final DartType returnType;

  MethodInfo(ClassElement element, [this.prefix = 'extract'])
      : tagName = AnnotationReader.getAnnotation<tag>(element, 'value'),
        returnType = element.thisType;

  String get constantName => typeName + 'Name';
  String get name => '$prefix$typeName';
  String get startVar => '_' + ReCase(typeName).camelCase;
  String get typeName => returnType.getDisplayString(withNullability: false);
}
