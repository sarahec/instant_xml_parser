import 'package:runtime/annotations.dart';

@tag('w:b')
class Bold {
  @alias('w:val')
  @ifMatches(r'(on|1)')
  final bool enabled;

  Bold(this.enabled);
}

@tag('w:i')
class Italic {
  @alias('w:val')
  @ifMatches(r'(on|1)')
  final bool enabled;

  Italic(this.enabled);
}

@tag('w:u')
class Underline {
  @alias('w:val')
  @ifMatches(r'(on|1)')
  final bool enabled;

  Underline(this.enabled);
}
