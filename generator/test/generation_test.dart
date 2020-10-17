import 'package:test/test.dart';

import 'wrapped_generator.dart';

void main() {
  final g = WrappedGenerator();
  var generated;

  group('boilerplate', () {
    setUp(() async {
      generated = await g.generate('''
        import 'package:runtime/annotations.dart';

        @tag('empty')
        class EmptyTag {
          EmptyTag();
        }
        
        class NoTag {
          NoTag();
        }''');
    });

    test('has class wrapper',
        () => expect(generated, contains('class Parser {')));

    test('has runtime getter',
        () => expect(generated, contains('ParserRuntime get _pr')));

    test('ignores untagged class',
        () => expect(generated, isNot(contains('extractNoTag'))));

    test('extracts Future',
        () => expect(generated, contains('Future<EmptyTag> extract')));

    test('incorporates tag name',
        () => expect(generated, contains('Future<EmptyTag> extractEmptyTag')));

    test('includes tag constant',
        () => expect(generated, contains("const EmptyTagName = 'empty'")));

    test(
        'finds tag in stream',
        () =>
            expect(generated, contains('.startOf(events, name: EmptyTagName')));

    test('consumes to end',
        () => expect(generated, contains('.endOf(events, _emptyTag)')));

    test('creates object',
        () => expect(generated, contains('return EmptyTag()')));
  });

  group('attribute extraction', () {
    setUp(() async {
      generated = await g.generate('''
        import 'package:runtime/annotations.dart';

        @tag('identification')
        class NameTag {
          final String name;
          final int id;
          final double score;
          final bool registered;

          NameTag(this.name, this.registered, {this.id=0});
        }''');
    });

    test(
        'picks up tag name',
        () => expect(
            generated, contains("const NameTagName = 'identification'")));

    test('reads attributes', () {
      expect(generated, contains(".namedAttribute<String>(_nameTag, 'name')"));
      expect(generated, contains(".namedAttribute<int>(_nameTag, 'id')"));
      expect(generated, contains(".namedAttribute<double>(_nameTag, 'score')"));
      expect(
          generated, contains(".namedAttribute<bool>(_nameTag, 'registered')"));
    });

    // test('warns about unused fields',
    //     () => expect(warnings, contains('Unused fields: id, score')));

    test(
        'creates object with known fields',
        () => expect(
            generated, contains('return NameTag(name, registered, id: id)')));
  });
}
