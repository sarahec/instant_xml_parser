import 'package:ixp_runtime/annotations.dart';

// Copyright 2021 Google LLC
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

@tag('identification')
class NameTag {
  final String? name;
  @textElement
  final String? nickname;

  NameTag(this.name, {this.nickname});
}

@tag('extended')
class ExtendedNameTag {
  final String name;
  @textElement
  final String nickname;

  ExtendedNameTag(this.name, this.nickname);
}
