import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:mockito/mockito.dart';
import 'package:parse_tools/annotations.dart';
import 'package:test/test.dart';

// ignore: avoid_relative_lib_imports, UseAttribute(attributeName)
import '../lib/src/symtable/field_entry.dart';

void main() {
  const fieldName = 'xyzzy';
  const attributeName = 'quux';
  const attributeTag = '_quux';
  const parentTag = 'parent';

  var stringType;
  var stringField;

  setUp(() {
    stringType = MockType();
    when(stringType.isDartCoreString).thenReturn(true);

    stringField = MockFieldElement();
    when(stringField.name).thenReturn(fieldName);
    when(stringField.type).thenReturn(stringType);
  });

  group('string field', () {
    test('defaults', () {
      var entry = FieldEntry.fromElement(stringField);
      expect(entry.name, equals(fieldName));
      expect(entry.type, equals(stringType));
      expect(entry.attribute, equals(fieldName));
    });

    test('override attribute name', () {
      var entry = FieldEntry.fromElement(stringField,
          annotation: UseAttribute(attributeName));
      expect(entry.name, equals(fieldName));
      expect(entry.type, equals(stringType));
      expect(entry.attribute, equals(attributeName));
    });

    test('override attribute name and tag', () {
      var entry = FieldEntry.fromElement(stringField,
          tag: parentTag,
          annotation: UseAttribute(attributeName, tag: attributeTag));
      expect(entry.name, equals(fieldName));
      expect(entry.type, equals(stringType));
      expect(entry.attribute, equals(attributeName));
      expect(entry.tag, equals(attributeTag));
    });

    test('rejects accidental parent tag in annotation', () {
      var entry = FieldEntry.fromElement(stringField,
          tag: parentTag,
          annotation: UseAttribute(attributeName, tag: parentTag));
      expect(entry.name, equals(fieldName));
      expect(entry.type, equals(stringType));
      expect(entry.attribute, equals(attributeName));
      expect(entry.tag, isNull);
    });
  });
}

class MockFieldElement extends Mock implements FieldElement {}

class MockType extends Mock implements DartType {}
