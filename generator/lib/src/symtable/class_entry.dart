import 'package:analyzer/dart/element/element.dart';
import 'package:meta/meta.dart';
import 'package:recase/recase.dart';
import 'package:runtime/annotations.dart';

import 'field_entry.dart';

T _getAnnotation<T>(Element element) =>
    _hasAnnotation<T>(element) ? element.metadata.whereType<T>().first : null;
bool _hasAnnotation<T>(Element element) =>
    element.metadata != null && element.metadata.whereType<T>().isNotEmpty;

class ClassEntry {
  final String className;
  final String method;
  final String tag;
  final Iterable<FieldEntry> fields;

  @visibleForTesting
  ClassEntry(
      {@required this.className,
      @required this.method,
      @required this.tag,
      @required this.fields});

  factory ClassEntry.fromElement(ClassElement element) {
    assert(_hasAnnotation<Tag>(element), '@Tag required');
    final annotation = _getAnnotation<Tag>(element);
    return ClassEntry(
        className: element.getDisplayString(withNullability: false),
        method: annotation?.method ?? ReCase(element.name).camelCase,
        tag: annotation?.tag,
        fields: element.fields.map((f) => FieldEntry.fromElement(f,
            tag: tag, annotation: _getAnnotation<UseAttribute>(f))));
  }
}
