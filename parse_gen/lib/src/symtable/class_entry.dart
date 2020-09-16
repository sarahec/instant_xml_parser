import 'package:built_value/built_value.dart';

import 'field_entry.dart';

part 'class_entry.g.dart';

abstract class ClassEntry implements Built<ClassEntry, ClassEntryBuilder> {
  String get className;
  String get method;
  String get tag;
  List<FieldEntry> get fields;

  ClassEntry._();
  factory ClassEntry([void Function(ClassEntryBuilder) updates]) = _$ClassEntry;
}
