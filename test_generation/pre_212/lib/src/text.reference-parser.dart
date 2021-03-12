// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ParseMethodGenerator
// **************************************************************************

import 'dart:async';
import 'package:async/async.dart';
import 'package:xml/xml_events.dart';
import 'nullable_parsers/text.dart';
import 'dart:core';
import 'package:logging/logging.dart';
import 'package:ixp_runtime/ixp_runtime.dart';

const NameTagName = 'text';
final _log = Logger('parser');
Future<NameTag> extractNameTag(StreamQueue<XmlEvent> events) async {
  final found = await events.scanTo(startTag(named(NameTagName)));
  if (!found) {
    throw MissingStartTag(NameTagName);
  }
  final _nameTag = await events.peek as XmlStartElementEvent;
  _log.finest('in text');

  var name;
  if (await events.scanTo(textElement(inside(_nameTag)))) {
    name = (await events.peek as XmlTextEvent).text;
  } else {
    name = 'sam';
  }

  _log.finest('consume text');
  await events.consume(inside(_nameTag));
  return NameTag(name: name);
}
