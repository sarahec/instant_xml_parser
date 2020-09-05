import 'package:docx_extractor/annotations.dart';

part 'example.g.dart';

@FromXML('hello')
class Hello {
  final String name;

  Hello(this.name);
}
