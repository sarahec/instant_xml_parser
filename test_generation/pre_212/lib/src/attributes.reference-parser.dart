// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ParseMethodGenerator
// **************************************************************************

import 'dart:async';
import 'package:async/async.dart';
import 'package:xml/xml_events.dart';
import 'attributes.dart';
import 'dart:core';
import 'package:logging/logging.dart';
import 'package:ixp_runtime/ixp_runtime.dart';

const NameTagName = 'identification';
final _log = Logger('parser');
Future<NameTag> extractNameTag(StreamQueue<XmlEvent> events) async {
  final found = await events.scanTo(startTag(named(NameTagName)));
  if (!found) {
    throw MissingStartTag(NameTagName);
  }
  final _nameTag = await events.peek as XmlStartElementEvent;
  _log.finest('in identification');

  final name = await _nameTag.optionalAttribute<String>('name');
  final registered = await _nameTag.optionalAttribute<bool>('registered');
  final id = await _nameTag.optionalAttribute<int>('id') ?? 0;

  _log.finest('consume identification');
  await events.consume(inside(_nameTag));
  return NameTag(name, registered, id: id);
}
