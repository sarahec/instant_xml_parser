import 'package:runtime/runtime.dart';
import 'package:xml/xml_events.dart';

extension AttributeExtension on XmlStartElementEvent {
  /// Extracts an attribute from an element, converting it into a desired type.
  ///
  /// Looks for the named attribute on the supplied element, supplying a
  /// converter automatically if possible. Returns the value if found,
  /// ```null``` if not found, or throws ```Future.error``` if not found and
  /// marked as required.
  ///
  /// [T] the type to return
  /// [elementFuture] the start tag
  /// [attributeName] the name of the attribute to find. Accepts fully
  /// qualified or unqualified names.
  /// [convert] (optional) if supplied, applies a converter of the form
  /// ```T Function (String s)``` to the found value. If not supplied,
  /// calls ```autoConverter(T)``` to find a converter.
  /// [isRequired] (optional) if true, throws a ```Future.error``` if the
  /// attribute isn't found.
  /// [defaultValue] (optional) if supplied, a missing attribute will return
  /// this value instead.
  ///
  /// Typical call:
  /// ```final name = _pr.namedAttribute<String>(_startTag, 'name')```
  Future<T> namedAttribute<T>(String attributeName,
      {Converter<T> convert, isRequired = false, T defaultValue}) async {
    convert = convert ?? autoConverter(T);
    assert(convert != null || T == String, 'converter required');

    // if the name has a namespace, match exactly. If it doesn't,
    // try a namespace-free match
    final attribute = attributes.firstWhere(
        (a) =>
            (a.name == attributeName) ||
            (_stripNamespace(a.name) == attributeName),
        orElse: () => null);
    final value = attribute?.value;

    if (value == null) {
      if (isRequired) {
        return Future.error(MissingAttribute(name, attributeName));
      }
      // If we're returning the default value, we can bypass the converter
      return value ?? defaultValue;
    }

    return convert == null ? value : convert(value);
  }

  String _stripNamespace(String s) => s.split(':').last;
}
