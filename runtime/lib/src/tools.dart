library runtime;

import 'package:async/async.dart';
import 'package:xml/xml_events.dart';

StreamQueue<XmlEvent> generateEventStream(Stream<String> source) => StreamQueue(
    source.toXmlEvents().withParentEvents().normalizeEvents().flatten());
