import 'package:test/test.dart';
import '../lib/parsers.dart'; // ignore: avoid_relative_lib_imports
import 'package:ixp_runtime/ixp_runtime.dart';

void main() {
  test('all present', () async {
    final nameTag = await extractNameTag(generateEventStream(
        Stream.value('<identification name="Frank" registered="1" id="2" />')));
    expect(nameTag.name, equals('Frank'));
    expect(nameTag.registered, isTrue);
    expect(nameTag.id, equals(2));
  });

  test('default values', () async {
    final nameTag = await extractNameTag(generateEventStream(
        Stream.value('<identification name="Frank" registered="1" />')));
    expect(nameTag.id, equals(0));
  });

  test('missing required', () async {
    expect(
        extractNameTag(generateEventStream(
            Stream.value('<identification name="Frank" />'))),
        throwsA(TypeMatcher<MissingAttribute>()));
  });
}
