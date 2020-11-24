/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
library runtime;

typedef Converter<T> = T Function(String s);

class Convert {
  static Converter<String> get identity => (s) => s;

  static Converter<bool> get toBool =>
      (s) => s != null && (s == '1' || s == 'true' || s == 'TRUE');

  static Converter<double> get toDouble => (s) => double.parse(s);

  static Converter<int> get toInt => (s) => int.parse(s);

  static Converter<bool> ifEquals(value) => (s) => value == s;

  static Converter<bool> ifMatches(regexp) => (s) => RegExp(regexp).hasMatch(s);
}

/// Returns a converter from String to the specified built-in type.
///
/// Use the ```@converter``` tag for non-primitive types instead
Converter autoConverter(Type T) => (T == bool)
    ? Convert.toBool
    : (T == int)
        ? Convert.toInt
        : (T == double)
            ? Convert.toDouble
            : null;
