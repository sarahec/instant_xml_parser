// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ParseMethodGenerator
// **************************************************************************

import 'dart:async';
import 'package:async/async.dart';
import 'package:xml/xml_events.dart';
import 'package:runtime/runtime.dart';
import 'elements.dart';

class Parser {
  static const BodyName = 'w:body';

  static const BreakName = 'w:br';

  static const DocumentName = 'w:document';

  static const LineBreakName = 'w:cr';

  static const ParagraphName = 'w:p';

  static const TextRunName = 'w:r';

  static const TextSegmentName = 'w:t';

  Future<Body> extractBody(StreamQueue<XmlEvent> events) async {
    final _body =
        await _pr.startOf(events, name: BodyName, failOnMismatch: true);
    if (_body == null) return null;

    var paragraphs = <Paragraph>[];
    var probe = await _pr.startOf(events, parent: _body);
    while (probe != null) {
      switch (probe.qualifiedName) {
        case ParagraphName:
          paragraphs.add(await extractParagraph(events));
          break;
        default:
          await _pr.logUnknown(probe, BodyName);
          await _pr.consume(events, 1);
      }
      probe = await _pr.startOf(events, parent: _body);
    }
    await _pr.endOf(events, _body);
    return Body(paragraphs);
  }

  Future<Break> extractBreak(StreamQueue<XmlEvent> events) async {
    final _break =
        await _pr.startOf(events, name: BreakName, failOnMismatch: true);
    if (_break == null) return null;
    final breakType = await _pr.namedAttribute<String>(_break, 'w:type');

    await _pr.endOf(events, _break);
    return Break();
  }

  Future<Document> extractDocument(StreamQueue<XmlEvent> events) async {
    final _document =
        await _pr.startOf(events, name: DocumentName, failOnMismatch: true);
    if (_document == null) return null;

    var body;
    var probe = await _pr.startOf(events, parent: _document);
    while (probe != null) {
      switch (probe.qualifiedName) {
        case BodyName:
          body = await extractBody(events);
          break;
        default:
          await _pr.logUnknown(probe, DocumentName);
          await _pr.consume(events, 1);
      }
      probe = await _pr.startOf(events, parent: _document);
    }
    await _pr.endOf(events, _document);
    return Document(body);
  }

  Future<LineBreak> extractLineBreak(StreamQueue<XmlEvent> events) async {
    final _lineBreak =
        await _pr.startOf(events, name: LineBreakName, failOnMismatch: true);
    if (_lineBreak == null) return null;

    await _pr.endOf(events, _lineBreak);
    return LineBreak();
  }

  Future<Paragraph> extractParagraph(StreamQueue<XmlEvent> events) async {
    final _paragraph =
        await _pr.startOf(events, name: ParagraphName, failOnMismatch: true);
    if (_paragraph == null) return null;

    var textRuns = <TextRun>[];
    var probe = await _pr.startOf(events, parent: _paragraph);
    while (probe != null) {
      switch (probe.qualifiedName) {
        case TextRunName:
          textRuns.add(await extractTextRun(events));
          break;
        default:
          await _pr.logUnknown(probe, ParagraphName);
          await _pr.consume(events, 1);
      }
      probe = await _pr.startOf(events, parent: _paragraph);
    }
    await _pr.endOf(events, _paragraph);
    return Paragraph(textRuns);
  }

  Future<TextRun> extractTextRun(StreamQueue<XmlEvent> events) async {
    final _textRun =
        await _pr.startOf(events, name: TextRunName, failOnMismatch: true);
    if (_textRun == null) return null;

    var segments = <RunSegment>[];
    var probe = await _pr.startOf(events, parent: _textRun);
    while (probe != null) {
      switch (probe.qualifiedName) {
        case TextSegmentName:
          segments.add(await extractTextSegment(events));
          break;

        case BreakName:
          segments.add(await extractBreak(events));
          break;

        case LineBreakName:
          segments.add(await extractLineBreak(events));
          break;
        default:
          await _pr.logUnknown(probe, TextRunName);
          await _pr.consume(events, 1);
      }
      probe = await _pr.startOf(events, parent: _textRun);
    }
    await _pr.endOf(events, _textRun);
    return TextRun(segments);
  }

  Future<TextSegment> extractTextSegment(StreamQueue<XmlEvent> events) async {
    final _textSegment =
        await _pr.startOf(events, name: TextSegmentName, failOnMismatch: true);
    if (_textSegment == null) return null;
    final space = await _pr.namedAttribute<String>(_textSegment, 'xml:space');
    final rawValue = await _pr.textOf(events, _textSegment);

    await _pr.endOf(events, _textSegment);
    return TextSegment(space, rawValue);
  }

  ParserRuntime get _pr => ParserRuntime();
  StreamQueue<XmlEvent> generateEventStream(Stream<String> source) =>
      StreamQueue(
          source.toXmlEvents().withParentEvents().normalizeEvents().flatten());
}
