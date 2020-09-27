import 'package:analyzer/dart/element/type.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:generator/src/source_gen.dart';
import 'package:generator/src/symtable.dart';

void main() {
  group('TestData testData(...)', () {
    var testDataType;
    var methodEntry;
    var source;

    setUp(() {
      testDataType = MockType.withDisplayString('TestData');
      methodEntry =
          MethodEntry(name: 'testData', tag: 'test', returns: testDataType);
      source = MethodSourceGen(methodEntry).toSource;
    });

    test('declaration', () {
      expect(
          source,
          startsWith(
              'FutureOr<TestData> testData(StreamQueue<XmlEvent> events) async'));
    });

    test('tag check', () {
      print(source);
      expect(source, contains("await hasStartTag(events, withName: 'test'"));
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
