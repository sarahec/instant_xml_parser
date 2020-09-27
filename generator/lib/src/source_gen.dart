import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:generator/src/symtable.dart';
import 'package:meta/meta.dart';

Code _attributeConverter(DartType type, [FieldEntry entry]) {
  if (type.isDartCoreBool) {
    if (entry?.trueIfMatches != null) {
      return Code('ifMatches(${entry.trueIfMatches})');
    }
    if (entry?.trueIfEquals != null) {
      return Code('ifEquals(${entry.trueIfEquals})');
    }
    // else
    throw AssertionError('Bool requires either a string or regexp to match');
  }
  if (type.isDartCoreDouble) return Code('toDouble)');
  if (type.isDartCoreInt) return Code('toInt');
  return null;
}

Expression _readAttribute(attribute, DartType type) =>
    refer('namedAttribute').call([refer('element'), literalString(attribute)],
        {}, [refer(type.getDisplayString(withNullability: false))]);

class ClassMethodGen {
  final ClassEntry entry;

  ClassMethodGen(this.entry);

  Method get toMethod => MethodSourceGen(entry.method).toMethod;
}

class FieldSourceGen {
  final FieldEntry entry;

  FieldSourceGen(this.entry);

  Code get toVar => entry.initVar
      ? _readAttribute(entry.attribute, entry.type).assignFinal(entry.name)
      : Code('var ${entry.name}');
}

class MethodSourceGen {
  final MethodEntry entry;

  Method get toMethod => Method((b) => b
    ..name = entry.name
    ..body = literalNull.code
    ..modifier = MethodModifier.async
    ..requiredParameters.add(parameter)
    ..returns = refer(returnTypeName));

  String get toSource => DartEmitter().visitMethod(toMethod).toString();

  Parameter get parameter => Parameter((b) => b
    ..name = 'events'
    ..type = Reference('StreamQueue<XmlEvent>'));

  @visibleForTesting
  Code get startingAssertion => Code(
      "assert(element.name == '${entry.tag}', 'Expected tag: ${entry.tag}')");

  @visibleForTesting
  Code get attributeAccess => Code(
      "namedAttribute<${entry.returnType}>(element, '${entry.attribute}')");

  @visibleForTesting
  String get returnTypeName =>
      'FutureOr<' +
      entry.returns.getDisplayString(withNullability: false) +
      '>';

  MethodSourceGen(this.entry);
}
