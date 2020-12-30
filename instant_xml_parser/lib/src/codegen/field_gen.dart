/// Pluggable code emitters for attributes, text fields, and child tags.
///
/// Don't confuse the name "Generator" here with the generators used by
/// ```source_gen```, these generate code fragments for use within a parser.

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
library parse_generator;

import 'package:instant_xml_parser/src/info/field_info.dart';
import 'package:instant_xml_parser/src/info/symtable.dart';
import 'package:logging/logging.dart';

import '../info/method_info.dart';

/// Emits the code for reading a single attribute (with optional type
/// conversion.)
///
/// This handles: type conversion (```@convert```), boolean matching,
/// and default values (if specified in the constructor).
class AttributeFieldGenerator {
  /// Parsed information from the source field
  final FieldInfo field;

  /// Parsed information about the containing method
  final MethodInfo method;

  /// Parsed information about the containing file
  final Symtable symtable;

  AttributeFieldGenerator(this.field, this.method, this.symtable);

  /// Generate the code
  String get toAction {
    final defaultValue =
        (field.defaultValueCode == null) ? '' : ' ?? ${field.defaultValueCode}';

    var conversion = ''; // if none match, write nothing
    if (field.hasConversion) {
      conversion = ', convert: ${field.conversion}';
    } else if (field.type.isDartCoreBool) {
      if (field.trueIfEquals != null) {
        conversion = ", convert: Convert.ifEquals('${field.trueIfEquals}')";
      } else if (field.trueIfMatches != null) {
        conversion = ", convert: Convert.ifMatches('${field.trueIfMatches}')";
      }
    }

    return "final ${field.name} = await ${method.startVar}.namedAttribute<${field.typeName}>('${field.attributeName}' $conversion)$defaultValue;";
  }
}

/// Emits the code for reading an XML text event.
///
/// This handles: type conversion (```@convert```)
/// and default values (if specified in the constructor).
class TextFieldGenerator {
  final FieldInfo field;
  final MethodInfo method;
  final Symtable symtable;

  TextFieldGenerator(this.field, this.method, this.symtable);

  /// Generate the code
  String get toAction {
    final defaultValue =
        (field.defaultValueCode == null) ? '' : ' ?? ${field.defaultValueCode}';
    final textOf =
        ' (await events.find(textElement(inside(${method.startVar}))) as XmlTextEvent)?.text $defaultValue';
    final extraction =
        field.hasConversion ? '${field.conversion}($textOf)' : textOf;
    return 'final ${field.name} = $extraction;';
  }
}

/// Emits the code for reading a child tag from within a parent.
///
/// See [MethodGenerator.methodBody] for context.
///
/// The emitted code is in two parts:
/// 1. A variable declaration to hold the result
/// 2. The ```case``` statement that recognizes the tag and calls its parsing
/// method.
class TagFieldGenerator {
  final FieldInfo field;
  final MethodInfo method;
  final Symtable symtable;

  final _log = Logger('TagFieldGenerator');

  TagFieldGenerator(this.field, this.method, this.symtable);

  String _action(MethodInfo foreignMethod) =>
      'await ${foreignMethod.name}(events)';

  /// Generate the case statement
  String get toAction {
    final methods = symtable.methodsReturning(field.type);
    if (methods == null) {
      final warning = 'No method found for ${field.typeName}';
      _log.warning(warning);
      return '// $warning\n';
    }

    return [
      for (var m in methods)
        '''
        case ${m.classInfo.constantName}:
          ${field.isList ? '${field.name}.add(${_action(m)})' : ' ${field.name}= ${_action(m)}'};
        break;'''
    ].join('\n\n');
  }

  /// Generate the variable declaration (which may be a list)
  String get vardecl {
    final varInit = (field.defaultValueCode != null)
        ? ' = ${field.defaultValueCode}'
        : field.isList
            ? ' = <${field.typeName}>[]'
            : '';
    return 'var ${field.name}$varInit;';
  }
}
