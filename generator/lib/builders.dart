import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'package:generator/src/generators/parse_method_generator.dart';

Builder parserBuilder(BuilderOptions options) =>
    LibraryBuilder(ParseMethodGenerator(), generatedExtension: '.parser.dart');
