import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:generator/parse_method_generator.dart';
import 'package:logging/logging.dart';
import 'package:source_gen/source_gen.dart';

// Test setup adapted from built_value (thank you, kevmoo@)

class WrappedGenerator {
  final String pkgName = 'pkg';

  final Builder builder = LibraryBuilder(ParseMethodGenerator(),
      generatedExtension: '.parser.dart');

  String error;
  List<String> warnings;

  Future<String> generate(String source) async {
    var srcs = <String, String>{
      'runtime|lib/annotations.dart': annotationsSource,
      '$pkgName|lib/structures.dart': source,
    };

    // Capture any error from generation; if there is one, return that instead of
    // the generated output.

    void captureError(LogRecord logRecord) {
      if (logRecord.error is InvalidGenerationSourceError) {
        if (error != null) throw StateError('Expected at most one error.');
        error = logRecord.error.toString();
      }
    }

    error = null;
    warnings = <String>[];
    var writer = InMemoryAssetWriter();
    await testBuilder(builder, srcs,
        rootPackage: pkgName, writer: writer, onLog: captureError);
    return error ??
        String.fromCharCodes(
            writer.assets[AssetId(pkgName, 'lib/structures.parser.dart')] ??
                []);
  }

  static const String annotationsSource = r'''
library annotations;
class tag {
  final String value;

  const tag(this.value);
}

const textElement = TextElement();

class TextElement {
  const TextElement();
}

class convert {
  final String source;

  const convert(this.source);
}

''';
}
