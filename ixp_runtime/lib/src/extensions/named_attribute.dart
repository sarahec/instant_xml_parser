// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
import 'package:ixp_runtime/runtime.dart';
import 'package:xml/xml_events.dart';

extension AttributeExtension on XmlStartElementEvent {
  /// Extracts an attribute from an element, converting it into a desired type.
  ///
  /// Looks for the named attribute on the supplied element, supplying a
  /// converter automatically if possible. Returns the value if found,
  /// `null` if not found, or throws `Future.error` if not found and
  /// marked as required.
  ///
  /// [T] the type to return
  /// [elementFuture] the start tag
  /// [attributeName] the name of the attribute to find. Accepts fully
  /// qualified or unqualified names.
  /// [convert] (optional) if supplied, applies a converter of the form
  /// `T Function (String s)` to the found value. If not supplied,
  /// calls `autoConverter(T)` to find a converter.
  /// [isRequired] (optional) if true, throws a `Future.error` if the
  /// attribute isn't found.
  /// [defaultValue] (optional) if supplied, a missing attribute will return
  /// this value instead.
  ///
  /// Typical call:
  /// `final name = _pr.namedAttribute<String>(_startTag, 'name')`
  @Deprecated('use attribute or optionalAttribute')
  Future<T?> namedAttribute<T>(String attributeName,
      {Converter<T>? convert, isRequired = false, T? defaultValue}) async {
    final probe = await optionalAttribute<T>(attributeName, convert: convert);
    if (probe == null && isRequired) {
      return Future.error(MissingAttribute(name, attributeName));
    }
    return probe ?? defaultValue!;
  }

  /// Extracts an attribute by name. Throws `MissingAttribute` if not found.
  ///
  /// [T] The type to return. Specify as e.g. `attribute<double>(...)`)
  /// Defaults to `String`.
  /// [attributeName] the name of the attribute to find. Accepts fully
  /// qualified or unqualified names.
  /// [converter] A function of the form `T Function(String)` that parses
  /// the string to an object. Not needed for any of the primitive types or
  /// `Uri`. (See [autoConverter])
  Future<T> attribute<T>(String attributeName, {Converter<T>? convert}) async {
    final probe = await optionalAttribute<T>(attributeName, convert: convert);
    if (probe == null) {
      throw MissingAttribute(name, attributeName);
    }
    return probe;
  }

  /// Checks for the presence of an attribute. Returns `true` if found.
  ///
  /// [attributeName] the fully qualified or unqualified name.
  Future<bool> hasAttribute(String attributeName) async => attributes.any((a) =>
      (a.name == attributeName) || (_stripNamespace(a.name) == attributeName));

  /// Extracts an attribute by name. Returns `null` if not found.
  ///
  /// [T] The type to return. Specify as e.g. `attribute<double>(...)`)
  /// Defaults to `String`.
  /// [attributeName] the name of the attribute to find. Accepts fully
  /// qualified or unqualified names.
  /// [converter] A function of the form `T Function(String)` that parses
  /// the string to an object. Not needed for any of the primitive types or
  /// `Uri`. (See [autoConverter])
  Future<T?> optionalAttribute<T>(String attributeName,
      {Converter<T>? convert}) async {
    convert = convert ?? autoConverter(T);
    try {
      return convert(attributes
          .firstWhere((a) =>
              (a.name == attributeName) ||
              (_stripNamespace(a.name) == attributeName))
          .value);
    } catch (_) {
      return null;
    }
  }

  String _stripNamespace(String s) => s.split(':').last;
}
