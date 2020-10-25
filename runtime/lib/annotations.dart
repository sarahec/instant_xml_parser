library runtime.annotations;

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

class tag {
  final String value;

  const tag(this.value);
}

class text {
  const text();
}
