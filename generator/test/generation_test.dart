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

  group('attributes', () {
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
      expect(generated, contains(".namedAttribute<int>(_nameTag, 'id') ?? 0;"));
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

  group('text', () {
    setUp(() async {
      generated = await g.generate('''
        import 'package:runtime/annotations.dart';

        @tag('text')
        class NameTag {
          @text()
          final String name;

          NameTag({this.name='sam'});
        }''');
    });

    test(
        'extracts text',
        () => expect(generated,
            contains('final name = await pr.textOf(events, _nameTag)')));

    test(
        'applies default',
        () =>
            expect(generated, contains("textOf(events, _nameTag) ?? 'sam';")));

    test('uses named parameter in constructor',
        () => expect(generated, contains('return NameTag(name: name);')));
  });

  group('conversion', () {
    setUp(() async {
      generated = await g.generate('''
        import 'package:runtime/annotations.dart';

        @tag('loc')
        class Location {
          final String foo; 

          @text()
          @convert('Uri.parse')
          final Uri loc;

          @convert('Uri.parse')
          final Uri altLoc;

          NameTag(this.loc, this.altLoc);
        }''');
    });

    test(
        'foo',
        () => expect(
            generated, contains(".namedAttribute<String>(_location, 'foo')")));
    test(
        'attribute',
        () => expect(
            generated,
            contains(
                ".namedAttribute<Uri>(_location, 'altLoc', convert: Uri.parse)")));

    test(
        '@text',
        () => expect(
            generated,
            contains(
                'final loc = Uri.parse(await pr.textOf(events, _location))')));
  });

  group('subclassing', () {
    setUp(() async {
      generated = await g.generate('''
        import 'package:runtime/annotations.dart';

        abstract class Foo {
          final String name;

          Foo(this.name);
        }

        @tag('bar')
        class Bar extends Foo {
          
          Bar(name) : Foo(name);
        }''');
    });

    test(
        'collects superclass field',
        () => expect(
            generated,
            contains(
                "final name = await pr.namedAttribute<String>(_bar, 'name');")));
  });

  group('children', () {
    setUp(() async {
      generated = await g.generate('''
        import 'package:runtime/annotations.dart';

        @tag('contact')
        class ContactInfo {
          final String email;
          final String phone;

          ContactInfo([this.email, this.phone]);
        }

        @tag('registration')
        class Registration {
          final NameTag person;
          final ContactInfo contact;
          final int age;

          Registration(this.person, {this.contact=ContactInfo(), this.age=99});
        }''');
    });

    test(
        'extracts child',
        () =>
            expect(generated, contains('contact = await extractContactInfo')));
    test('applies default',
        () => expect(generated, contains('var contact = ContactInfo();')));
  });

  group('imports', () {
    setUp(() async {
      generated = await g.generate('''
        import 'package:runtime/annotations.dart';
        import 'other.dart';

        @tag('contact')
        class ContactInfo {
          final String email;
          final String phone;

          ContactInfo([this.email, this.phone]);
        }

        }''');
    });

    test('passes to generated code',
        () => expect(generated, contains("import 'other.dart';")));
  });
}
