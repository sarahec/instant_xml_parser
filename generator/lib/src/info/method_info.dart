import 'package:built_value/built_value.dart';
import 'package:recase/recase.dart';
import 'package:analyzer/dart/element/element.dart';

import 'class_info.dart';
import 'field_info.dart';

part 'method_info.g.dart';

abstract class MethodInfo implements Built<MethodInfo, MethodInfoBuilder> {
  factory MethodInfo([void Function(MethodInfoBuilder) updates]) = _$MethodInfo;
  factory MethodInfo.fromClassInfo(
          ClassInfo info, Iterable<FieldElement> fields,
          [prefix = 'extract']) =>
      MethodInfo((b) => b
        ..classInfo = info.toBuilder()
        ..prefix = prefix
        ..name = '$prefix$typeName'
        ..fields = fields
            .where((f) => f.getter.isGetter && !f.isSynthetic)
            .map((f) => FieldInfo.fromElement(f)));
  MethodInfo._();
  ClassInfo get classInfo;

  Iterable<FieldInfo> get fields;

  String get name;

  String get prefix;

  @memoized
  String get startVar => '_' + ReCase(typeName).camelCase;

  String get typeName => classInfo.typeName;
}
