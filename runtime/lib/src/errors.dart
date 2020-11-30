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

class EndOfQueue implements ParsingError {
  final String reason;

  EndOfQueue([this.reason = '']);

  @override
  String get message => 'End of queue $reason';
}

class MissingAttribute implements ParsingError {
  final String tag;
  final String attribute;

  MissingAttribute(this.tag, this.attribute);

  @override
  String get message => 'Missing attribute value $tag::$attribute';
}

class MissingStartTag implements ParsingError {
  final String wanted;
  final String found;

  MissingStartTag(this.wanted, {this.found = ''});

  @override
  String get message => 'Expected <$wanted> at start';
}

class MissingEndTag implements ParsingError {
  final String wanted;

  MissingEndTag(this.wanted);

  @override
  String get message => 'Expected </$wanted>';
}

class UnexpectedChild implements ParsingError {
  final String tag;

  UnexpectedChild(this.tag);

  @override
  String get message => 'Found unexpected child inside <$tag/>';
}

abstract class ParsingError {
  String get message;

  @override
  String toString() => message;
}
