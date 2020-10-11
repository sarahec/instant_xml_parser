import 'package:analyzer/dart/element/element.dart';
import 'package:logging/logging.dart';
import 'package:source_gen/source_gen.dart';

class AnnotationReader {
  static final _log = Logger('AnnotationReader');

  static dynamic getAnnotation<A>(Element element, String field,
      [Type type = String]) {
    final _attributeChecker = TypeChecker.fromRuntime(A);
    final found = _attributeChecker.firstAnnotationOfExact(element,
        throwOnUnresolved: false);
    if (found == null) return null;
    dynamic result;
    switch (type) {
      case bool:
        result = found.getField(field)?.toIntValue();
        break;
      case double:
        result = found.getField(field)?.toDoubleValue();
        break;
      case int:
        result = found.getField(field)?.toIntValue();
        break;
      case Type:
        result = found.getField(field)?.toTypeValue();
        break;
      default:
        result = found.getField(field)?.toStringValue();
    }
    _log.finer('@$A.$field = $result');
    return result;
  }

  static dynamic hasAnnotation<A>(Element element) => TypeChecker.fromRuntime(A)
      .hasAnnotationOf(element, throwOnUnresolved: false);
}
