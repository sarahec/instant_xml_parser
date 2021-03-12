// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ParseMethodGenerator
// **************************************************************************

import 'dart:async';
import 'package:async/async.dart';
import 'package:xml/xml_events.dart';
import 'subclassing.dart';
import 'dart:core';
import 'package:logging/logging.dart';
import 'package:ixp_runtime/ixp_runtime.dart';

const BarName = 'bar';
final _log = Logger('parser');
Future<Bar> extractBar(StreamQueue<XmlEvent> events) async {
  final found = await events.scanTo(startTag(named(BarName)));
  if (!found) {
    throw MissingStartTag(BarName);
  }
  final _bar = await events.peek as XmlStartElementEvent;
  _log.finest('in bar');

  final name = await _bar.optionalAttribute<String>('name');

  _log.finest('consume bar');
  await events.consume(inside(_bar));
  return Bar(name);
}
