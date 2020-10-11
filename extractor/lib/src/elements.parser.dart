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
  static const DocumentName = 'w:document';

  static const BodyName = 'w:body';

  static const ParagraphName = 'w:p';

  static const TextRunName = 'w:r';

  static const TextName = 'w:t';

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
      }
      await events.skip(1);
      probe = await _pr.startOf(events, parent: _body);
    }
    await _pr.endOf(events, _body);
    return Body(paragraphs);
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
      }
      await events.skip(1);
      probe = await _pr.startOf(events, parent: _document);
    }
    await _pr.endOf(events, _document);
    return Document(body);
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
      }
      await events.skip(1);
      probe = await _pr.startOf(events, parent: _paragraph);
    }
    await _pr.endOf(events, _paragraph);
    return Paragraph(textRuns);
  }

  Future<Text> extractText(StreamQueue<XmlEvent> events) async {
    final _text =
        await _pr.startOf(events, name: TextName, failOnMismatch: true);
    if (_text == null) return null;
    final space = await _pr.namedAttribute<String>(_text, 'space');
    final value = await _pr.namedAttribute<String>(_text, 'value');
    final rawValue = await _pr.textOf(events, _text);

    await _pr.endOf(events, _text);
    return Text(space, rawValue);
  }

  Future<TextRun> extractTextRun(StreamQueue<XmlEvent> events) async {
    final _textRun =
        await _pr.startOf(events, name: TextRunName, failOnMismatch: true);
    if (_textRun == null) return null;

    var segments = <Text>[];
    var probe = await _pr.startOf(events, parent: _textRun);
    while (probe != null) {
      switch (probe.qualifiedName) {
        case TextName:
          segments.add(await extractText(events));
          break;
        default:
          await _pr.logUnknown(probe, TextRunName);
      }
      await events.skip(1);
      probe = await _pr.startOf(events, parent: _textRun);
    }
    await _pr.endOf(events, _textRun);
    return TextRun(segments);
  }

  ParserRuntime get _pr => ParserRuntime();
  StreamQueue<XmlEvent> generateEventStream(Stream<String> source) =>
      StreamQueue(
          source.toXmlEvents().withParentEvents().normalizeEvents().flatten());
}
