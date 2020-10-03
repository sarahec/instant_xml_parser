import 'package:analyzer/dart/element/type.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:generator/src/source_gen.dart';
import 'package:generator/src/symtable.dart';

import 'package:runtime/annotations.dart';

void main() {
  group('TestData testData(...)', () {
    var testDataType;
    var methodEntry;
    var source;

    setUp(() {
      testDataType = MockType.withDisplayString('TestData');
      methodEntry =
          MethodEntry(name: 'testData', tag: 'test', returns: testDataType);
      var attributeField = FieldEntry(
          annotation: Attribute(attribute: 'attr'),
          name: 'attr',
          type: MockType.withDisplayString('String'));
      var structField = FieldEntry(
          annotation: null,
          name: 'person',
          type: MockType.withDisplayString('NameTag'));
      source =
          ParserSourceGen(methodEntry, [attributeField, structField]).toSource;
      print(source); // <<<
    });

    test('declaration', () {
      expect(
          source,
          startsWith(
              'FutureOr<TestData> extractTestData(StreamQueue<XmlEvent> events) async'));
    });
  });
}

class MockType extends Mock implements DartType {
  factory MockType.withDisplayString(displayString, {nullable = false}) {
    final result = MockType();
    when(result.getDisplayString(withNullability: nullable))
        .thenReturn(displayString);
    return result;
  }

  MockType() : super();
}
