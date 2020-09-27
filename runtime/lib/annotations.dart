library annotations;

class Tag {
  final String tag;
  final String method;
  final bool useStrict;

  const Tag(this.tag, {this.method, this.useStrict = false})
      : assert(tag != null, 'tag required');
}

/// Annotates a field inside a "tag" class to specify the attribute (and tag
/// if not in the parent tag.)
///
/// Notes:
/// * ```attribute``` is required
/// * ```tag``` is optional. If you supply it, the generated code will look for
///   that tag as a child and extract the attribute from there.
/// * Fill in ```equals``` or ```matches``` when annotating a boolean field.
class Attribute {
  /// Name for the attribute to extract
  final String attribute;

  /// The tag name, if not an attribute on the parent tag
  final String tag;

  /// Is this a required attribute?
  final bool isRequired;

  final dynamic defaultValue;

  /// If this is a boolean field, true when the attribute equals this value
  final String equals;

  /// If this is a boolean field, true when the attribute matches this regexp
  final RegExp matches;

  const Attribute(
      {this.attribute,
      this.tag,
      this.isRequired = false,
      this.defaultValue,
      this.equals,
      this.matches});
}

class IgnoreTag {
  final Iterable<String> tags;

  IgnoreTag({String tag, Iterable<String> tags})
      : assert(
            tag != null || tags != null, 'tag or tags (collection) required'),
        tags = tags ?? [tag];
}
