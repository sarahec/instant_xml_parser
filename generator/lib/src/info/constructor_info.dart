import 'package:analyzer/dart/element/element.dart';
import 'package:built_value/built_value.dart';

part 'constructor_info.g.dart';

abstract class ConstructorInfo
    implements Built<ConstructorInfo, ConstructorInfoBuilder> {
  ConstructorInfo._();
  factory ConstructorInfo([void Function(ConstructorInfoBuilder) updates]) =
      _$ConstructorInfo;

  factory ConstructorInfo.fromElement(ConstructorElement element) =>
      ConstructorInfo((b) => b.element = element);

  ConstructorElement get element;

  String get name => element.name;

  Iterable<ParameterElement> get parameters => element.parameters;

  Iterable<String> get parameterNames =>
      [for (var p in element.parameters) p.name];
}
