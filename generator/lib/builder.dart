import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'package:generator/parse_method_generator.dart';

Builder parseMethodBuilder(BuilderOptions options) =>
    LibraryBuilder(ParseMethodGenerator());
