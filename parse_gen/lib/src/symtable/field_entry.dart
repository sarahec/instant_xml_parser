import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:built_value/built_value.dart';
import 'package:runtime/annotations.dart';

part 'field_entry.g.dart';

abstract class FieldEntry implements Built<FieldEntry, FieldEntryBuilder> {
  /// (optional) The child tag to use. If null, looks for an attribute on the parent
  @nullable
  String get tag;

  /// The attribute name to read. Defauts to the field's name
  String get attribute;

  /// The field name
  String get name;

  /// (optional) If getting a class result from a child tag, this overrides the method's default name
  @nullable
  String get methodName;

  /// Type of this field
  DartType get type;

  /// (optional, for Boolean fields only) Evaluates as TRUE if attribute value equals this string
  @nullable
  String get trueIfEquals;

  /// (optional, for Boolean fields only) Evaluates as TRUE if attribute value matches this Regexp
  @nullable
  RegExp get trueIfMatches;

  bool get initVar => tag == null && attribute != null;

  bool get wantsTag => tag != null;

  bool get useAttribute => attribute != null;

  bool get callMethod => _callMethod(type);

  bool get buildList => type.isDartCoreIterable;

  bool get callMethodInList =>
      buildList && _callMethod((type as ParameterizedType).typeArguments.first);

  bool _callMethod(t) => methodName != null && !t.isDartCoreObject;

  FieldEntry._();
  factory FieldEntry([void Function(FieldEntryBuilder) updates]) = _$FieldEntry;

  factory FieldEntry.fromElement(FieldElement element,
          {UseAttribute annotation, String tag}) =>
      FieldEntry((b) => b
        // Annotation's tag overrides the parent's tag unless they match
        ..tag = (annotation?.tag != null && annotation.tag != tag)
            ? annotation.tag
            : null
        ..name = element.name
        ..attribute = annotation?.attribute ?? element.name
        ..methodName = null
        ..type = element.type
        ..trueIfEquals = annotation?.equals
        ..trueIfMatches = annotation?.matches);
}
