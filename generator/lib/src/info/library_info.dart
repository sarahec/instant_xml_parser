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
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart' show AssetId;
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:source_gen/source_gen.dart';

import 'class_info.dart';

part 'library_info.g.dart';

/// Per-file information used by the parser. Serialiazable so that the
/// first-pass builder can output this as JSON then reconstitute
/// in pass two to build the master symbol table as well as drive
/// generation.
abstract class LibraryInfo implements Built<LibraryInfo, LibraryInfoBuilder> {
  static Serializer<LibraryInfo> get serializer => _$libraryInfoSerializer;

  factory LibraryInfo([void Function(LibraryInfoBuilder) updates]) =
      _$LibraryInfo;

  factory LibraryInfo.fromLibrary(LibraryReader reader, AssetId asset) {
    return LibraryInfo((b) => b
      ..element = reader.element
      ..classes = [for (var c in reader.classes) ClassInfo.fromElement(c)]
      ..uri = asset.uri);
  }

  LibraryInfo._();

  Uri get uri;

  Iterable<ClassInfo> get classes;

  LibraryElement get element;

  @memoized
  Iterable<String> get importUris => element.imports.map((i) => i.uri);
}
