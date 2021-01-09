// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
library runtime;

typedef Converter<T> = dynamic Function(String s);

/// Conversion methods from String to the Dart primitive types.
class Convert {
  /// Converts '1', 'true', and 'TRUE' to ```true```.
  static Converter<bool> get toBool =>
      (s) => s != null && (s == '1' || s == 'true' || s == 'TRUE');

  /// Parses a double fron a string.
  static Converter<double> get toDouble => (s) => double.parse(s);

  /// Parses an int from a string.
  static Converter<int> get toInt => (s) => int.parse(s);

  /// Parses an int from a string.
  static Converter<Uri> get toUri => (s) => Uri.parse(s);

  /// Returns ```true``` if an attribute's string matches this value. Used by
  /// ```@ifEquals```.
  static Converter<bool> ifEquals(value) => (s) => value == s;

  /// Returns ```true``` if an attribute's string matches a regular expression.
  /// The expression is a raw string (```r'foo'```).
  static Converter<bool> ifMatches(regexp) => (s) => RegExp(regexp).hasMatch(s);
}

/// Returns a converter from String to the specified primitive type.
///
/// Note: Use the [convert] annotation for all other types.
Converter? autoConverter(Type T) => (T == bool)
    ? Convert.toBool
    : (T == int)
        ? Convert.toInt
        : (T == double)
            ? Convert.toDouble
            : (T == Uri)
                ? Convert.toUri
                : null;
