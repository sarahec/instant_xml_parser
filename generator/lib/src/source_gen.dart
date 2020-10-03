import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:generator/src/symtable.dart';
import 'package:meta/meta.dart';
import 'package:recase/recase.dart';

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

class FieldSourceGen {
  final FieldEntry entry;

  FieldSourceGen(this.entry);

  // TODO add a key: parameter with the entry's name
  Code get toAction => Code("GetAttr<$entryType>('${entry.attribute}')");

  String get entryType => entry.type.getDisplayString(withNullability: false);
}

class ParserSourceGen {
  final MethodEntry entry;
  final Iterable<FieldEntry> fields;

  final String prefix = 'extract';

  Method get toMethod => Method((b) => b
    ..name = prefix + ReCase(entry.name).pascalCase
    ..body = Block.of([parseCall, returnStructure])
    ..modifier = MethodModifier.async
    ..requiredParameters.add(parameter)
    ..returns = refer(returnTypeName));

  String get entryVar => entry.name;

  String get toSource => DartEmitter().visitMethod(toMethod).toString();

  Parameter get parameter => Parameter((b) => b
    ..name = 'events'
    ..type = Reference('StreamQueue<XmlEvent>'));

  @visibleForTesting
  Code get parseCall => Code('''
  final $entryVar = await pr.parse(events, '${entry.tag}' [$actions]);''');

  String get actions =>
      fields.map((f) => FieldSourceGen(f).toAction).join(',\n');

  @visibleForTesting
  Code get returnStructure => Code('''return $returnTypeName();''');

  // @visibleForTesting
  // Code get attributeAccess => Code(
  //     "namedAttribute<${entry.returnType}>(element, '${entry.attribute}')");

  @visibleForTesting
  String get returnTypeName =>
      'FutureOr<' +
      entry.returns.getDisplayString(withNullability: false) +
      '>';

  ParserSourceGen(this.entry, this.fields);
}
