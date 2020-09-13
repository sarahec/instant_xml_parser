import 'dart:async';
import 'package:async/async.dart';
import 'package:parse_tools/annotations.dart';
import 'package:parse_tools/parse_tools.dart';
import 'package:xml/xml_events.dart';

part 'example.g.dart';

@FromXML('empty')
class EmptyTag {
  EmptyTag();
}

@FromXML('named')
class NamedTag {
  final String name;

  NamedTag(this.name);
}
