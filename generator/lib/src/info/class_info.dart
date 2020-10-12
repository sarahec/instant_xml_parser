import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:built_value/built_value.dart';
import 'package:runtime/annotations.dart';

import '../utils/annotation_reader.dart';
import 'method_info.dart';

part 'class_info.g.dart';

abstract class ClassInfo implements Built<ClassInfo, ClassInfoBuilder> {
  factory ClassInfo([void Function(ClassInfoBuilder) updates]) = _$ClassInfo;
  factory ClassInfo.fromElement(ClassElement element, [prefix = 'extract']) =>
      ClassInfo((b) => b
        ..element = element
        ..tagName = AnnotationReader.getAnnotation<tag>(element, 'value')
        ..type = element.thisType);
  ClassInfo._();

  ClassElement get element;

  String get constantName => typeName + 'Name';

  @memoized
  MethodInfo get method =>
      needsMethod ? MethodInfo.fromClassInfo(this, element.fields) : null;

  @memoized
  ConstructorElement get constructor =>
      type.constructors.where((c) => c.isDefaultConstructor).first;

  bool get needsMethod => tagName != null;

  @nullable
  Iterable<ClassInfo> get subclasses;

  String get tagName;

  InterfaceType get type;

  @memoized
  String get typeName => type.getDisplayString(withNullability: false);
}
