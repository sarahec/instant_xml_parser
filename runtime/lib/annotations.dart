library annotations;

class alias {
  /// Name for the attribute to extract (if not inferred from the field name)
  final String name;

  const alias(this.name);
}

class ifEquals {
  final String value;

  const ifEquals(this.value);
}

class ifMatches {
  final String regex;

  const ifMatches(this.regex);
}

class ignore {
  final Iterable<String> tags;

  const ignore(this.tags);
}

class parser {
  final String name;

  const parser(this.name);
}

class tag {
  final String value;

  const tag(this.value);
}

const keep = '';
const trim = 'trim';
const msOffice = 'msOffice';

class text {
  /// Setting this to 'trim' removes whitespace
  /// Setting this to 'msOffice' uses special OOXML whitespace rules
  final String mode;

  const text([this.mode = trim]);
}
