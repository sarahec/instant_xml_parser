import 'package:analyzer/dart/element/type.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:generator/src/source_gen.dart';
import 'package:generator/src/symtable.dart';

void main() {
  group('TestData method', () {
    var testDataType;

    setUp(() {
      testDataType = MockType.withDisplayString('TestData');
    });

    test('method declaration', () {
      final methodEntry =
          MethodEntry(name: 'testData', tag: 'test', returns: testDataType);
      final source = MethodSourceGen(methodEntry).toSource;
      expect(
          source,
          startsWith(
              'FutureOr<TestData> testData(StreamQueue<XmlEvent> events) async'));
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
