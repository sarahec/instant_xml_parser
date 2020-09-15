library annotations;

class Tag with TagInfo {
  final String tag;
  final String method;

  const Tag(this.tag, {this.method}) : assert(tag != null, 'tag required');
}

class Attribute with TagInfo {
  @override
  final String tag;
  final String attribute;
  @override
  final String method;
  final String match;

  Attribute(this.attribute, {this.tag, this.method, this.match});
}

mixin TagInfo {
  String get tag;
  String get method;
}
