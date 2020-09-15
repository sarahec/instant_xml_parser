library parse_gen.class_entry;

import 'package:analyzer/dart/element/type.dart';
import 'package:built_value/built_value.dart';
import 'package:analyzer/dart/element/element.dart';

part 'class_entry.g.dart';

abstract class ClassEntry implements Built<ClassEntry, ClassEntryBuilder> {
  String get className;
  String get methodName;
  String get tagName;

  ClassEntry._();
  factory ClassEntry([void Function(ClassEntryBuilder) updates]) = _$ClassEntry;
}
