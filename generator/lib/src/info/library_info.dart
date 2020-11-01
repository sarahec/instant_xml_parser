import 'package:analyzer/dart/element/element.dart';
import 'package:built_value/built_value.dart';
import 'package:generator/src/info/symtable.dart';
import 'package:source_gen/source_gen.dart';

part 'library_info.g.dart';

abstract class LibraryInfo implements Built<LibraryInfo, LibraryInfoBuilder> {
  factory LibraryInfo([void Function(LibraryInfoBuilder) updates]) =
      _$LibraryInfo;
  factory LibraryInfo.fromLibrary(LibraryReader reader) => LibraryInfo((b) => b
    ..element = reader.element
    ..symtable = Symtable.fromLibrary(reader));

  LibraryInfo._();

  LibraryElement get element;
  @memoized
  Iterable<String> get importUris => element.imports.map((i) => i.uri);

  Symtable get symtable;
}
