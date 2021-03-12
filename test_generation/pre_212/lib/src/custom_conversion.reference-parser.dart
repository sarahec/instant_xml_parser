// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ParseMethodGenerator
// **************************************************************************

import 'dart:async';
import 'package:async/async.dart';
import 'package:xml/xml_events.dart';
import 'custom_conversion.dart';
import 'dart:core';
import 'package:logging/logging.dart';
import 'package:ixp_runtime/ixp_runtime.dart';

const LocationName = 'loc';
final _log = Logger('parser');
Future<Location> extractLocation(StreamQueue<XmlEvent> events) async {
  final found = await events.scanTo(startTag(named(LocationName)));
  if (!found) {
    throw MissingStartTag(LocationName);
  }
  final _location = await events.peek as XmlStartElementEvent;
  _log.finest('in loc');

  final fooCompleter = Completer<String>();
  final foo = fooCompleter.future;

  final altLoc = await _location.optionalAttribute<Uri>('altLoc');

  fooCompleter.complete('Hello, world');
  _log.finest('consume loc');
  await events.consume(inside(_location));
  return Location(await foo, altLoc);
}
