import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:meta/meta.dart';
import 'package:recase/recase.dart';
import 'package:runtime/annotations.dart';

T _getAnnotation<T>(Element element) =>
    _hasAnnotation<T>(element) ? element.metadata.whereType<T>().first : null;
bool _hasAnnotation<T>(Element element) =>
    element.metadata != null && element.metadata.whereType<T>().isNotEmpty;

class ClassEntry {
  final String name;
  final Tag annotation;
  final Iterable<FieldEntry> fields;

  MethodEntry get method => MethodEntry.fromClassEntry(this);

  @visibleForTesting
  ClassEntry(this.name, this.annotation, this.fields);

  factory ClassEntry.fromElement(ClassElement element) {
    assert(_hasAnnotation<Tag>(element), '@Tag required');
    final className = element.getDisplayString(withNullability: false);
    final annotation = _getAnnotation<Tag>(element);
    final fields = element.fields.map((f) => FieldEntry.fromElement(f,
        tag: annotation.tag, annotation: _getAnnotation<UseAttribute>(f)));
    return ClassEntry(className, annotation, fields);
  }
}

class FieldEntry {
  /// (optional) The child tag to use. If null, looks for an attribute on the parent
  final String tag;

  /// (optional) The attribute name to read. Defauts to the field's name
  final String attribute;

  /// The field name
  final String name;

  /// (optional) If getting a class result from a child tag, this overrides the method's default name
  final String methodName;

  /// Type of this field
  final DartType type;

  /// (optional, for Boolean fields only) Evaluates as TRUE if attribute value equals this string
  final String trueIfEquals;

  final RegExp trueIfMatches;

  bool get initVar => tag == null && attribute != null;

  bool get wantsTag => tag != null;

  bool get useAttribute => attribute != null;

  bool get callMethod => _callMethod(type);

  bool get buildList => type.isDartCoreIterable;

  bool get callMethodInList =>
      buildList && _callMethod((type as ParameterizedType).typeArguments.first);

  bool _callMethod(t) => methodName != null && !t.isDartCoreObject;

  FieldEntry.fromElement(FieldElement element,
      {UseAttribute annotation, String tag})
      : tag = (annotation?.tag != null && annotation?.tag != tag)
            ? annotation?.tag
            : null,
        name = element.name,
        methodName = null, // TODO implement method name when appropriate
        attribute = annotation?.attribute ?? element.name,
        type = element.type,
        trueIfEquals = annotation?.equals,
        trueIfMatches = annotation?.matches;

  @visibleForTesting
  FieldEntry(
      {this.tag,
      this.attribute,
      this.name,
      this.methodName,
      this.type,
      this.trueIfEquals,
      this.trueIfMatches});
}

class MethodEntry {
  final String name;
  final String tag;

  @visibleForTesting
  MethodEntry(this.name, this.tag);

  MethodEntry.fromClassEntry(ClassEntry classEntry)
      : name =
            classEntry.annotation.method ?? ReCase(classEntry.name).camelCase,
        tag = classEntry.annotation.tag;
}
