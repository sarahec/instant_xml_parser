/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
library parse_generator;

import 'package:generator/src/info/field_info.dart';
import 'package:generator/src/info/symtable.dart';
import 'package:logging/logging.dart';

import '../info/method_info.dart';

class AttributeFieldGenerator {
  final FieldInfo field;
  final MethodInfo method;
  final Symtable symtable;

  AttributeFieldGenerator(this.field, this.method, this.symtable);

  String get toAction {
    final defaultValue =
        (field.defaultValueCode == null) ? '' : ' ?? ${field.defaultValueCode}';

    var conversion = ''; // if none match, write nothing
    if (field.hasConversion) {
      conversion = ', convert: ${field.conversion}';
    } else if (field.type.isDartCoreBool) {
      if (field.trueIfEquals != null) {
        conversion = ", convert: Convert.ifEquals('${field.trueIfEquals}')}";
      } else if (field.trueIfMatches != null) {
        conversion = ", convert: Convert.ifMatches('${field.trueIfMatches}')";
      }
    }

    return "final ${field.name} = await ${method.startVar}.namedAttribute<${field.typeName}>('${field.attributeName}' $conversion)$defaultValue;";
  }
}

class TextFieldGenerator {
  final FieldInfo field;
  final MethodInfo method;
  final Symtable symtable;

  TextFieldGenerator(this.field, this.method, this.symtable);

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

class TagFieldGenerator {
  final FieldInfo field;
  final MethodInfo method;
  final Symtable symtable;

  final _log = Logger('TagFieldGenerator');

  TagFieldGenerator(this.field, this.method, this.symtable);

  String action(MethodInfo foreignMethod) =>
      'await ${foreignMethod.name}(events)';

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
          ${field.isList ? '${field.name}.add(${action(m)})' : ' ${field.name}= ${action(m)}'};
        break;'''
    ].join('\n\n');
  }

  String get vardecl {
    final varInit = (field.defaultValueCode != null)
        ? ' = ${field.defaultValueCode}'
        : field.isList
            ? ' = <${field.typeName}>[]'
            : '';
    return 'var ${field.name}$varInit;';
  }
}
