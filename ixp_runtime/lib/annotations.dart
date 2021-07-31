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

library runtime.annotations;

/// Defines the XML attribute name for a field when the attribute name doesn't
/// match the field name.
///
///[name] The fully qualified attribute name.
///
/// Example:
/// `
/// class TextSegment {
///   @alias('xml:space')
///   final String space;
/// `
class alias {
  /// Name for the attribute to extract (if not inferred from the field name)
  final String name;

  const alias(this.name);
}

/// Labels the constructor to use when there's more than one available.
const constructor = Constructor();

/// Use `@constructor`
class Constructor {
  const Constructor();
}

/// Defines the String-to-value conversion for this field.
///
/// The runtime converts String to any of the Dart primitives, but needs
/// explicit code to convert any other types.
/// [source] The name of a method that takes a single String and returns
/// the desired type.
///
/// Example:
///`
/// @tag('loc')
/// class Location {
///   @convert('Uri.parse')
///   final Uri loc;
///
///   NameTag(this.loc);
/// }
/// `
class convert {
  final String source;

  const convert(this.source);
}

/// Injects  code into the parser to set up the current attribute
/// (e.g. when `@convert` isn't adequate)
///
/// [template] the string to be injected to the target code. Use a raw
/// string if you want to include string interpolation.
class custom {
  final String template;

  const custom(this.template);
}

/// Defines a `bool` that is true when the field contains a certain string.
///
/// [value] The string to match (case-sensitive)
///
/// Example:
/// `
/// class Circuit {
///   @ifEquals('on')
///   bool power;
/// `
class ifEquals {
  final String value;

  const ifEquals(this.value);
}

/// Defines a `bool` that is true when the field contains a certain regular
/// expression.
///
/// [value] The regex to match. Using a raw string is recommended.
///
/// Example:
/// `
/// class Circuit {
///   @ifMatches(r'(on|1)')
///   bool power;
/// `
class ifMatches {
  final String regex;

  const ifMatches(this.regex);
}

/// Specifies the XML tag for a class.
///
/// [value] The fully qualified tag name.
///
/// Example:
/// `
/// ///`
/// @tag('loc')
/// class Location {
/// `
class tag {
  final String value;

  const tag(this.value);
}

/// Denotes a field as coming from the XML text inside the current tag.
///
/// Example:
/// `dart
/// @tag('note')
/// class Note {
///   @textElement
///   final String body;
///
///   Note(this.body);
/// }
/// `
/// `xml
/// <note>This is a test</node>
/// `
const textElement = TextElement();

/// Use `@textElement`
class TextElement {
  const TextElement();
}
