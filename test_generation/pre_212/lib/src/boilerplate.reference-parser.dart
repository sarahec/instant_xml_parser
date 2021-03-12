// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ParseMethodGenerator
// **************************************************************************

import 'dart:async';
import 'package:async/async.dart';
import 'package:xml/xml_events.dart';
import 'boilerplate.dart';
import 'dart:core';
import 'package:logging/logging.dart';
import 'package:ixp_runtime/ixp_runtime.dart';

const EmptyTagName = 'empty';
final _log = Logger('parser');
Future<EmptyTag> extractEmptyTag(StreamQueue<XmlEvent> events) async {
  final found = await events.scanTo(startTag(named(EmptyTagName)));
  if (!found) {
    throw MissingStartTag(EmptyTagName);
  }
  final _emptyTag = await events.peek as XmlStartElementEvent;
  _log.finest('in empty');

  _log.finest('consume empty');
  await events.consume(inside(_emptyTag));
  return EmptyTag();
}
