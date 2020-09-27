class EndOfQueue implements ParsingError {
  final String reason;

  EndOfQueue([this.reason = '']);

  @override
  String get message => 'End of queue $reason';
}

class MissingStartTag implements ParsingError {
  final String tag;

  MissingStartTag(this.tag);

  @override
  String get message => 'Expected <$tag> at start';
}

abstract class ParsingError {
  String get message;

  @override
  String toString() => message;
}
