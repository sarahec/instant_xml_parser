typedef Convert = dynamic Function(String s);

Convert get toDouble => (s) => double.parse(s);

Convert get toInt => (s) => int.parse(s);

Convert ifEquals(value) => (s) => value == s;

Convert ifMatches(regexp) => (s) => regexp.hasMatch(s);
