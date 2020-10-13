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

  String get action {
    final foreignMethod = symtable.methodReturning(field.typeName);
    if (foreignMethod == null) {
      _log.warning('Extraction method not found for ${field.typeName}');
    }
    return 'await ${foreignMethod.name}(events)'; // TODO need methodname for field.type, get from symbol table?
  }

  String get toAction => '''
    case ${method.classInfo.constantName}:
      ${field.isList ? '${field.name}.add($action)' : ' ${field.name}= $action'};
    break;''';

  String get vardecl => field.isList
      ? 'var ${field.name} = <${field.typeName}>[];'
      : 'var ${field.name};';
}
