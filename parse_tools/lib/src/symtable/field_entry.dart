import 'package:analyzer/dart/element/type.dart';
import 'package:built_value/built_value.dart';

part 'field_entry.g.dart';

abstract class FieldEntry implements Built<FieldEntry, FieldEntryBuilder> {
  @nullable
  String get tagName;

  @nullable
  String get attributeName;

  String get name;

  @nullable
  String get methodName;

  DartType get type;

  bool get initVar => tagName == null && attributeName != null;

  bool get useText => attributeName == null && type.isDartCoreString;

  bool get wantsTag => tagName != null;

  bool get useAttribute => attributeName != null;

  bool get callMethod => _callMethod(type);

  bool get buildList => type.isDartCoreIterable;

  bool get callMethodInList =>
      buildList && _callMethod((type as ParameterizedType).typeArguments.first);

  bool _callMethod(t) => methodName != null && !t.isDartCoreObject;

  FieldEntry._();
  factory FieldEntry([void Function(FieldEntryBuilder) updates]) = _$FieldEntry;
}
