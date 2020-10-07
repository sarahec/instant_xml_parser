import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

mixin AnnotationReader {
  static dynamic getAnnotation<A>(Element element,
      [String field, Type type = String]) {
    final _attributeChecker = TypeChecker.fromRuntime(A);
    final found = _attributeChecker.firstAnnotationOfExact(element,
        throwOnUnresolved: false);
    if (found == null) return null;
    if (field == null) return found.toStringValue();
    switch (type) {
      case bool:
        found.getField(field)?.toIntValue();
        break;
      case double:
        found.getField(field)?.toDoubleValue();
        break;
      case int:
        found.getField(field)?.toIntValue();
        break;
      case Type:
        found.getField(field)?.toTypeValue();
        break;
      default:
        return found.getField(field)?.toStringValue();
    }
  }
}
