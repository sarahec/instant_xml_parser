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
    var conversion = ''; // if none match, write nothing
    if (field.type.isDartCoreBool) {
      if (field.trueIfEquals != null) {
        conversion = ", convert: Convert.ifEquals('${field.trueIfEquals}'}";
      } else if (field.trueIfMatches != null) {
        conversion = ', convert: Convert.ifMatches(${field.trueIfMatches}';
      }
    }
    return "final ${field.name} = await _pr.namedAttribute<${field.typeName}>(${method.startVar}, '${field.attributeName}' $conversion);";
  }
}

class TextFieldGenerator {
  final FieldInfo field;
  final MethodInfo method;
  final Symtable symtable;

  TextFieldGenerator(this.field, this.method, this.symtable);

  String get toAction =>
      'final ${field.name} = await _pr.textOf(events, ${method.startVar});';
}

class TagFieldGenerator {
  final FieldInfo field;
  final MethodInfo method;
  final Symtable symtable;

  final _log = Logger('TagFieldGenerator');

  TagFieldGenerator(this.field, this.method, this.symtable);

  String action(MethodInfo foreignMethod) {
    return 'await ${foreignMethod.name}(events)';
  }

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

  String get vardecl => field.isList
      ? 'var ${field.name} = <${field.typeName}>[];'
      : 'var ${field.name};';
}
