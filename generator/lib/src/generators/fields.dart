library parse_generator;

import 'package:generator/src/info/field_info.dart';
import 'package:generator/src/info/symtable.dart';

import '../info/method_info.dart';

class AttributeFieldGenerator {
  final FieldInfo field;
  final MethodInfo method;
  final Symtable symtable;

  AttributeFieldGenerator(this.field, this.method, this.symtable);

  String get toAction {
    var conversion;
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

  TagFieldGenerator(this.field, this.method, this.symtable);

  String get action => 'await ${method.name}(events)';

  String get toAction => '''
    case ${method.classInfo.constantName}:
      ${field.name}${field.isList ? '.add($action)' : '= $action'};
    break;''';

  String get vardecl => field.isList
      ? 'var ${field.name} = <${field.typeName}>[];'
      : 'var ${field.name};}';
}
