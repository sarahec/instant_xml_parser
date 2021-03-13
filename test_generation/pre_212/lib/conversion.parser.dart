// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ParseMethodGenerator
// **************************************************************************

import 'dart:async';
import 'package:async/async.dart';
import 'package:xml/xml_events.dart';
import 'conversion.dart';
import 'dart:core';
import 'package:logging/logging.dart';
import 'package:ixp_runtime/runtime.dart';

const LocationName = 'loc';
final _log = Logger('parser');
Future<Location> extractLocation(StreamQueue<XmlEvent> events) async {
  final found = await events.scanTo(startTag(named(LocationName)));
  if (!found) {
    throw MissingStartTag(LocationName);
  }
  final _location = await events.peek as XmlStartElementEvent;
  _log.finest('in loc');

  final altLoc =
      await _location.optionalAttribute<Uri>('altLoc', convert: Uri.parse);
  var loc;
  if (await events.scanTo(textElement(inside(_location)))) {
    loc = Uri.parse((await events.peek as XmlTextEvent).text);
  } else {
    loc = '';
  }

  _log.finest('consume loc');
  await events.consume(inside(_location));
  return Location(loc, altLoc);
}
