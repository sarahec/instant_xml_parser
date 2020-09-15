library annotations;

class Tag {
  final String tag;
  final String method;

  const Tag(this.tag, {this.method}) : assert(tag != null, 'tag required');
}

class Attribute {
  final String attribute;
  final String tag;
  final String matches;

  Attribute(this.attribute, {this.tag, this.matches});
}
