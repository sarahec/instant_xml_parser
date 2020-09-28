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
  final Tag annotation;
  final Iterable<FieldEntry> fields;
  final DartType type;

  // Memoize the result of generating a method entry
  MethodEntry _method;

  @visibleForTesting
  ClassEntry(
      {@required this.annotation, @required this.type, @required this.fields});

  factory ClassEntry.fromElement(ClassElement element) {
    assert(_hasAnnotation<Tag>(element), '@Tag required');
    final annotation = _getAnnotation<Tag>(element);
    final type = element.thisType;
    final fields = element.fields.map((f) => FieldEntry.fromElement(f,
        parentTag: annotation.tag, annotation: _getAnnotation<Attribute>(f)));
    return ClassEntry(annotation: annotation, type: type, fields: fields);
  }

  MethodEntry get method =>
      _method ?? (_method = MethodEntry.fromClassEntry(this));

  String get name => type.getDisplayString(withNullability: false);

  String get tag => annotation.tag;
}

class FieldEntry {
  final Attribute annotation;
  final String name;
  final String trueIfEquals;
  final RegExp trueIfMatches;
  final DartType type;

  /// Tag associated with the enclosing class
  final String _parentTag;

  @visibleForTesting
  FieldEntry(
      {@required this.annotation,
      @required this.name,
      @required this.type,
      @required this.trueIfEquals,
      @required this.trueIfMatches,
      @required parentTag})
      : _parentTag = parentTag;

  FieldEntry.fromElement(FieldElement element,
      {Attribute annotation, String parentTag})
      : annotation = annotation,
        name = element.getDisplayString(withNullability: false),
        type = element.type,
        trueIfEquals = annotation?.equals,
        trueIfMatches = annotation?.matches,
        _parentTag = parentTag;

  /// The attribute name to read (or null)
  ///
  /// Convenience feature: If the annotation exists but doesn't specify a name,
  /// uses the field name.
  String get attribute =>
      annotation != null ? (annotation.attribute ?? name) : null;

  /// The child tag to use, or null if using the parent tag's attribute
  String get tag => annotation?.tag != _parentTag ? annotation?.tag : null;

  bool get initVar => tag == null && attribute != null;

  bool get wantsTag => tag != null;

  bool get useAttribute => attribute != null;

  bool get callMethod => _callMethod(type);

  bool get buildList => type.isDartCoreIterable;

  bool get callMethodInList =>
      buildList && _callMethod((type as ParameterizedType).typeArguments.first);

  bool _callMethod(t) => name != null && !t.isDartCoreObject;
}

class MethodEntry {
  final String attribute;
  final String name;
  final DartType returns;
  final String tag;

  @visibleForTesting
  MethodEntry(
      {@required this.name,
      @required this.tag,
      this.attribute,
      @required this.returns});

  MethodEntry.fromClassEntry(ClassEntry classEntry)
      : name = ReCase(classEntry.name).camelCase,
        tag = classEntry.annotation.tag,
        attribute = null,
        returns = classEntry.type;

  MethodEntry.fromFieldEntry(FieldEntry entry)
      : name = 'get${ReCase(entry.name).pascalCase}',
        tag = entry.tag,
        attribute = entry.attribute,
        returns = entry.type;

  String get returnType => returns.getDisplayString(withNullability: false);
}
