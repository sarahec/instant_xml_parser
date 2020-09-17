import 'package:analyzer/dart/element/element.dart';
import 'package:built_value/built_value.dart';
import 'package:runtime/annotations.dart';
import 'package:recase/recase.dart';

import 'field_entry.dart';

part 'class_entry.g.dart';

abstract class ClassEntry implements Built<ClassEntry, ClassEntryBuilder> {
  String get className;
  String get method;
  String get tag;
  Iterable<FieldEntry> get fields;

  factory ClassEntry.fromElement(ClassElement element) {
    final annotation = element.metadata?.whereType<Tag>()?.first;
    assert(annotation != null, '@Tag annotation required');
    final tag = annotation.tag;
    return ClassEntry((b) => b
      ..className = element.name
      ..method = annotation.method ?? ReCase(element.name).camelCase
      ..tag = tag
      ..fields = element.fields.map((f) => FieldEntry.fromElement(f,
          tag: tag, annotation: f.metadata?.whereType<UseAttribute>()?.first)));
  }

  ClassEntry._();
  factory ClassEntry([void Function(ClassEntryBuilder) updates]) = _$ClassEntry;
}
