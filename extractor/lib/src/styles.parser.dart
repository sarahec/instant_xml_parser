// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ParseMethodGenerator
// **************************************************************************

import 'dart:async';
import 'package:async/async.dart';
import 'package:xml/xml_events.dart';
import 'package:runtime/runtime.dart';
import 'styles.dart';

const BoldName = 'w:b';
const ItalicName = 'w:i';
const UnderlineName = 'w:u';
Future<Bold> extractBold(StreamQueue<XmlEvent> events, ParserRuntime pr) async {
  final _bold = await pr.startOf(events, name: BoldName, failOnMismatch: true);
  if (_bold == null) return null;
  final enabled = await pr.namedAttribute<bool>(_bold, 'w:val',
      convert: Convert.ifMatches('(on|1)'));

  await pr.endOf(events, _bold);
  return Bold(enabled);
}

Future<Italic> extractItalic(
    StreamQueue<XmlEvent> events, ParserRuntime pr) async {
  final _italic =
      await pr.startOf(events, name: ItalicName, failOnMismatch: true);
  if (_italic == null) return null;
  final enabled = await pr.namedAttribute<bool>(_italic, 'w:val',
      convert: Convert.ifMatches('(on|1)'));

  await pr.endOf(events, _italic);
  return Italic(enabled);
}

Future<Underline> extractUnderline(
    StreamQueue<XmlEvent> events, ParserRuntime pr) async {
  final _underline =
      await pr.startOf(events, name: UnderlineName, failOnMismatch: true);
  if (_underline == null) return null;
  final enabled = await pr.namedAttribute<bool>(_underline, 'w:val',
      convert: Convert.ifMatches('(on|1)'));

  await pr.endOf(events, _underline);
  return Underline(enabled);
}
