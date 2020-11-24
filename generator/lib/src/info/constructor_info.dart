/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
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
