import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'package:parse_gen/parse_method_generator.dart';

Builder parseMethodBuilder(BuilderOptions options) =>
    SharedPartBuilder([ParseMethodGenerator()], 'parse_gen');
