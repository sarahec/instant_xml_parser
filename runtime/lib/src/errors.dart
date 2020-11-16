library runtime;

class EndOfQueue implements ParsingError {
  final String reason;

  EndOfQueue([this.reason = '']);

  @override
  String get message => 'End of queue $reason';
}

class MissingAttribute implements ParsingError {
  final String tag;
  final String attribute;

  MissingAttribute(this.tag, this.attribute);

  @override
  String get message => 'Missing attribute value $tag::$attribute';
}

class MissingStartTag implements ParsingError {
  final String wanted;
  final String found;

  MissingStartTag(this.wanted, {this.found = ''});

  @override
  String get message => 'Expected <$wanted> at start';
}

class MissingEndTag implements ParsingError {
  final String wanted;

  MissingEndTag(this.wanted);

  @override
  String get message => 'Expected </$wanted>';
}

class UnexpectedChild implements ParsingError {
  final String tag;

  UnexpectedChild(this.tag);

  @override
  String get message => 'Found unexpected child inside <$tag/>';
}

abstract class ParsingError {
  String get message;

  @override
  String toString() => message;
}
