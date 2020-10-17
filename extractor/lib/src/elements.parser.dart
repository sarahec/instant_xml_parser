// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ParseMethodGenerator
// **************************************************************************

import 'dart:async';
import 'package:async/async.dart';
import 'package:xml/xml_events.dart';
import 'package:runtime/runtime.dart';
import 'elements.dart';

const BodyName = 'w:body';
const BreakName = 'w:br';
const DocumentName = 'w:document';
const LineBreakName = 'w:cr';
const ParagraphName = 'w:p';
const TextRunName = 'w:r';
const TextSegmentName = 'w:t';
Future<Body> extractBody(StreamQueue<XmlEvent> events, ParserRuntime pr) async {
  final _body = await pr.startOf(events, name: BodyName, failOnMismatch: true);
  if (_body == null) return null;

  var paragraphs = <Paragraph>[];
  var probe = await pr.startOf(events, parent: _body);
  while (probe != null) {
    switch (probe.qualifiedName) {
      case ParagraphName:
        paragraphs.add(await extractParagraph(events, pr));
        break;
      default:
        await pr.logUnknown(probe, BodyName);
        await pr.consume(events, 1);
    }
    probe = await pr.startOf(events, parent: _body);
  }
  await pr.endOf(events, _body);
  return Body(paragraphs);
}

Future<Break> extractBreak(
    StreamQueue<XmlEvent> events, ParserRuntime pr) async {
  final _break =
      await pr.startOf(events, name: BreakName, failOnMismatch: true);
  if (_break == null) return null;
  final breakType = await pr.namedAttribute<String>(_break, 'w:type');

  await pr.endOf(events, _break);
  return Break(breakType);
}

Future<Document> extractDocument(
    StreamQueue<XmlEvent> events, ParserRuntime pr) async {
  final _document =
      await pr.startOf(events, name: DocumentName, failOnMismatch: true);
  if (_document == null) return null;

  var body;
  var probe = await pr.startOf(events, parent: _document);
  while (probe != null) {
    switch (probe.qualifiedName) {
      case BodyName:
        body = await extractBody(events, pr);
        break;
      default:
        await pr.logUnknown(probe, DocumentName);
        await pr.consume(events, 1);
    }
    probe = await pr.startOf(events, parent: _document);
  }
  await pr.endOf(events, _document);
  return Document(body);
}

Future<LineBreak> extractLineBreak(
    StreamQueue<XmlEvent> events, ParserRuntime pr) async {
  final _lineBreak =
      await pr.startOf(events, name: LineBreakName, failOnMismatch: true);
  if (_lineBreak == null) return null;

  await pr.endOf(events, _lineBreak);
  return LineBreak();
}

Future<Paragraph> extractParagraph(
    StreamQueue<XmlEvent> events, ParserRuntime pr) async {
  final _paragraph =
      await pr.startOf(events, name: ParagraphName, failOnMismatch: true);
  if (_paragraph == null) return null;

  var textRuns = <TextRun>[];
  var probe = await pr.startOf(events, parent: _paragraph);
  while (probe != null) {
    switch (probe.qualifiedName) {
      case TextRunName:
        textRuns.add(await extractTextRun(events, pr));
        break;
      default:
        await pr.logUnknown(probe, ParagraphName);
        await pr.consume(events, 1);
    }
    probe = await pr.startOf(events, parent: _paragraph);
  }
  await pr.endOf(events, _paragraph);
  return Paragraph(textRuns);
}

Future<TextRun> extractTextRun(
    StreamQueue<XmlEvent> events, ParserRuntime pr) async {
  final _textRun =
      await pr.startOf(events, name: TextRunName, failOnMismatch: true);
  if (_textRun == null) return null;

  var segments = <RunSegment>[];
  var probe = await pr.startOf(events, parent: _textRun);
  while (probe != null) {
    switch (probe.qualifiedName) {
      case TextSegmentName:
        segments.add(await extractTextSegment(events, pr));
        break;

      case BreakName:
        segments.add(await extractBreak(events, pr));
        break;

      case LineBreakName:
        segments.add(await extractLineBreak(events, pr));
        break;
      default:
        await pr.logUnknown(probe, TextRunName);
        await pr.consume(events, 1);
    }
    probe = await pr.startOf(events, parent: _textRun);
  }
  await pr.endOf(events, _textRun);
  return TextRun(segments);
}

Future<TextSegment> extractTextSegment(
    StreamQueue<XmlEvent> events, ParserRuntime pr) async {
  final _textSegment =
      await pr.startOf(events, name: TextSegmentName, failOnMismatch: true);
  if (_textSegment == null) return null;
  final space = await pr.namedAttribute<String>(_textSegment, 'xml:space');
  final rawValue = await pr.textOf(events, _textSegment);

  await pr.endOf(events, _textSegment);
  return TextSegment(space, rawValue);
}
