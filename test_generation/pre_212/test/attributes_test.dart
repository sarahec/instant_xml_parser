import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:instant_xml_parser/instant_xml_parser.dart';
import 'package:test/test.dart';

void main() {
  group('Attribute handling', () {
    test('nullable code matches', () async {
      final builder = parserBuilder(BuilderOptions.empty);

      await testBuilder(
          builder,
          {
            'ixp_runtime|annotations.dart': ANNOTATIONS_SRC,
            '$PACKAGE|attributes.dart': ATTRIBUTES_SRC
          },
          rootPackage: PACKAGE,
          outputs: {'$PACKAGE|attributes.parser.dart': ATTRIBUTES_PARSER});
    });
  });
}

const ANNOTATIONS_SRC = '''
class alias {
  /// Name for the attribute to extract (if not inferred from the field name)
  final String name;

  const alias(this.name);
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
''';

const PACKAGE = 'tests';

const ATTRIBUTES_SRC = '''
import 'package:ixp_runtime/annotations.dart';
@tag('identification')
class NameTag {
  final String name;
  final int id;
  final bool registered;

  NameTag(this.name, this.registered, {this.id = 0});
}
''';

const ATTRIBUTES_PARSER = '''// GENERATED CODE - DO NOT MODIFY BY HAND
            
// **************************************************************************
// ParseMethodGenerator
// **************************************************************************

import 'dart:async';
import 'package:async/async.dart';
import 'package:xml/xml_events.dart';
import 'attributes.dart';
import 'dart:core';
import 'package:logging/logging.dart';
import 'package:ixp_runtime/ixp_runtime.dart';

const NameTagName = 'identification';
final _log = Logger('parser');
Future<NameTag> extractNameTag(StreamQueue<XmlEvent> events) async {
  final found = await events.scanTo(startTag(named(NameTagName)));
  if (!found) {
    throw MissingStartTag(NameTagName);
  }
  final _nameTag = await events.peek as XmlStartElementEvent;
  _log.finest('in identification');

  final name = await _nameTag.optionalAttribute<String>('name');
  final registered = await _nameTag.optionalAttribute<bool>('registered');
  final id = await _nameTag.optionalAttribute<int>('id') ?? 0;

  _log.finest('consume identification');
  await events.consume(inside(_nameTag));
  return NameTag(name, registered, id: id);
}''';
