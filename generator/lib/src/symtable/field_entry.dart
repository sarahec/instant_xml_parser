import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:meta/meta.dart';
import 'package:runtime/annotations.dart';

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
