import 'package:analyzer/dart/element/type.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:generator/src/symtable.dart';

import 'package:runtime/annotations.dart';

void main() {
  group('TestData testData(...)', () {
    final testDataType = MockType.withDisplayString('TestData');
    var classEntry;
    var source;

    setUp(() {
      final attributeField = AttributeFieldEntry(
          annotation: Attribute(attribute: 'attr'),
          name: 'attr',
          type: MockType.withDisplayString('String'));
      final structField = TagFieldEntry(
          name: 'person', type: MockType.withDisplayString('NameTag'));
      classEntry = ClassEntry(
          annotation: Tag('testData'),
          type: testDataType,
          fields: [attributeField, structField]);
      source = classEntry.toSource;
      print(source); // <<<
    });

    test('declaration', () {
      expect(
          source,
          startsWith(
              'Future<TestData> extractTestData(StreamQueue<XmlEvent> events) async'));
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
