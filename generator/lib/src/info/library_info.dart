import 'package:build/build.dart';
import 'package:generator/src/info/symtable.dart';
import 'package:source_gen/source_gen.dart';

class LibraryInfo {
  final AssetId sourceAsset;
  final Symtable symtable;

  LibraryInfo.fromReader(LibraryReader reader, AssetId sourceAsset)
      : sourceAsset = sourceAsset,
        symtable = Symtable.fromLibrary(reader);
}
