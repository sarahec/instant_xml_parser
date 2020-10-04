import 'package:analyzer/dart/element/type.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:generator/src/actions.dart';
import 'package:generator/src/method.dart';

import 'package:runtime/annotations.dart';

void main() {
  group('extractTestData(...)', () {
    var source;

    setUp(() {
      final testDataType = MockType.withDisplayString('TestData');
      final attributeField = AttributeActionGenerator(
          annotation: Attribute(attribute: 'attr'),
          name: 'attr',
          type: MockType.withDisplayString('String'));
      final structField = MethodActionGenerator(
          name: 'person', type: MockType.withDisplayString('NameTag'));
      final classEntry = MethodGenerator(
          annotation: Tag('testData'),
          type: testDataType,
          fields: [attributeField, structField]);
      source = classEntry.toSource;
    });

    test('declaration', () {
      expect(
          source,
          startsWith(
              'Future<TestData> extractTestData(StreamQueue<XmlEvent> events) async'));
    });

    test('runtime call', () {
      expect(
          source,
          contains(
              'final testData = await pr.parse(events, TestDataTagName, ['));
    });

    test('actions', () {
      expect(source, contains("GetAttr<String>('attr ')"));
      expect(source, contains('GetTag<NameTag>(NameTagTagName, events)'));
    });
  });
}

class MockType extends Mock implements DartType {
  factory MockType.withDisplayString(displayString, {nullable = false}) {
    final result = MockType();
    when(result.getDisplayString(withNullability: nullable))
        .thenReturn(displayString);
    when(result.isDartCoreBool).thenReturn(displayString == 'bool');
    return result;
  }

  MockType() : super();
}
