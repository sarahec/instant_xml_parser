library runtime;

typedef Converter<T> = T Function(String s);

class Convert {
  static Converter<String> get identity => (s) => s;

  static Converter<bool> get toBool =>
      (s) => s != null && (s == '1' || s == 'true' || s == 'TRUE');

  static Converter<double> get toDouble => (s) => double.parse(s);

  static Converter<int> get toInt => (s) => int.parse(s);

  static Converter<bool> ifEquals(value) => (s) => value == s;

  static Converter<bool> ifMatches(regexp) => (s) => regexp.hasMatch(s);
}
