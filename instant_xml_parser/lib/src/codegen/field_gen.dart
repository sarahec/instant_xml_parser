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

import 'package:instant_xml_parser/src/info/source_info.dart';
import 'package:logging/logging.dart';

import '../info/method_info.dart';

/// Emits the code for reading a single attribute (with optional type
/// conversion.)
///
/// This handles: type conversion (```@convert```), boolean matching,
/// and default values (if specified in the constructor).
class AttributeFieldGenerator {
  /// Parsed information from the source field
  final CommonElement element;

  /// Parsed information about the containing method
  final MethodInfo method;

  /// Parsed information about the containing file
  final SourceInfo sourceInfo;

  AttributeFieldGenerator(this.element, this.method, this.sourceInfo);

  /// Generate the code
  String get toAction => element.field.isCustom ? setupDeferred : readAttribute;

  /// If this is a ```@custom``` field, final initialization won't happen until
  /// just before the constructor. This generates a [Completer] for
  /// deferred initialization.
  String get setupDeferred =>
      '''final ${element.field.name}Completer = Completer<${element.field.typeName}>(); 
      final ${element.field.name} = ${element.field.name}Completer.future;
      ''';

  /// Generate the code for reading and converting the attribute now, with
  /// type conversion from String and default value (if specified)
  String get readAttribute {
    final defaultValue = (element.field.defaultValueCode != null)
        ? ' ?? ${element.field.defaultValueCode}'
        : '';

    var conversion = ''; // if none match, write nothing
    if (element.field.hasConversion) {
      conversion = ', convert: ${element.field.conversion}';
    } else if (element.field.type.isDartCoreBool) {
      if (element.field.trueIfEquals != null) {
        conversion =
            ", convert: Convert.ifEquals('${element.field.trueIfEquals}')";
      } else if (element.field.trueIfMatches != null) {
        conversion =
            ", convert: Convert.ifMatches('${element.field.trueIfMatches}')";
      }
    }
    final action = element.isNullable ? 'optionalAttribute' : 'attribute';
    return "final ${element.field.name} = await ${method.startVar}.$action<${element.field.typeName}>('${element.field.attributeName}' $conversion)$defaultValue;";
  }

  String get resolveDeferred {
    final defaultValue = (element.field.defaultValueCode == null)
        ? ''
        : ' ?? ${element.field.defaultValueCode}';
    return '${element.field.name}Completer.complete(${element.field.customTemplate} $defaultValue);';
  }
}

/// Emits the code for reading an XML text event.
///
/// This handles: type conversion (```@convert```)
/// and default values (if specified in the constructor).
class TextFieldGenerator {
  final CommonElement element;
  final MethodInfo method;
  final SourceInfo sourceInfo;

  TextFieldGenerator(this.element, this.method, this.sourceInfo);

  /// Generate the code
  String get toAction {
    final defaultValue = (element.field.defaultValueCode == null)
        ? "''" // TODO this should throw an error instead
        : ' ${element.field.defaultValueCode}';

    final textOf = '(await events.peek as XmlTextEvent).text';

    final optionalConversion = element.field.hasConversion
        ? '${element.field.conversion}($textOf)'
        : textOf;

    return '''var ${element.field.name};
      if (await events.scanTo(textElement(inside(${method.startVar})))) {
        ${element.field.name} = $optionalConversion;
      } else {
        ${element.field.name} = $defaultValue;
      }''';
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
  final CommonElement element;
  final MethodInfo method;
  final SourceInfo sourceInfo;

  final _log = Logger('TagFieldGenerator');

  TagFieldGenerator(this.element, this.method, this.sourceInfo);

  String get customCode =>
      'final ${element.field.name} = ${element.field.customTemplate};';

  String _action(MethodInfo foreignMethod) =>
      'await ${foreignMethod.name}(events)';

  /// Generate the case statement
  String get toAction {
    final methods = sourceInfo.methodsReturning(element.field.type);
    if (methods == null) {
      final warning = 'No method found for ${element.field.typeName}';
      _log.warning(warning);
      return '// $warning\n';
    }

    return [
      for (var m in methods)
        '''
        case ${m.classInfo.constantName}:
          ${element.field.isList ? '${element.field.name}.add(${_action(m)})' : ' ${element.field.name}= ${_action(m)}'};
        break;'''
    ].join('\n\n');
  }

  /// Generate the variable declaration (which may be a list)
  String get vardecl {
    final varInit = (element.field.defaultValueCode != null)
        ? ' = ${element.field.defaultValueCode}'
        : element.field.isList
            ? ' = <${element.field.typeName}>[]'
            : '';
    return 'var ${element.field.name}$varInit;';
  }
}
