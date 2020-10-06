library annotations;

const optional = 'optional';

class attr {
  /// Name for the attribute to extract
  final String name;

  const attr(this.name);
}

class from {
  /// Name for the attribute to extract (if not inferred form the field name)
  final String attribute;
  final String tag;
  final Type type;

  const from({this.type, this.tag, this.attribute})
      : assert(type != null || tag != null);
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
