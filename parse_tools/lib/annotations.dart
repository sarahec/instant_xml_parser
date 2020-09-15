library annotations;

class FromXML {
  final String tag;

  const FromXML(this.tag) : assert(tag != null, 'tag required');
}

class FieldSource {
  final String tag;
  final String attribute;
  final String method;
  final String match;

  FieldSource({this.tag, this.attribute, this.method, this.match});
}
