library annotations;

class Tag {
  final String tag;
  final String method;

  const Tag(this.tag, {this.method}) : assert(tag != null, 'tag required');
}

class UseAttribute {
  final String attribute;
  final String tag;
  final String matches;

  UseAttribute(this.attribute, {this.tag, this.matches})
      : assert(attribute != null, 'attribute required');
}

class IgnoreTag {
  final Iterable<String> tags;

  IgnoreTag({String tag, Iterable<String> tags})
      : assert(
            tag != null || tags != null, 'tag or tags (collection) required'),
        tags = tags ?? [tag];
}
