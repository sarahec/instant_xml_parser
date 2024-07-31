# Generates an XML parser from annotated Dart code

Need to parse some complex XML?

1. Write a set of classes listing the values you want to extract
2. Annotate each class with a matching ```@tag()```
3. Annotate fields as needed (e.g. when the field name doesn't match its attribute name)
4. Run the generator
5. Use your shiny new parser.

This is especially useful when you have a piece of complex XML \*cough\*OOXML\*cough\* and want to import the data.

## Usage

### Your source

```dart
import 'package:ixp_runtime/annotations.dart';

@tag('ContactInfo')
class ContactInfo {
  final String email;
  final String phone;
  @textElement
  final String notes;

  ContactInfo(this.email, {this.phone, this.notes = ''});
}

@tag('addressBook')
class AddressBook {
  final List<ContactInfo> contacts;

  AddressBook(this.contacts);
}
```

### pubspec.yaml

```yaml
name: example
description: Annotates data classes for XML deserialization

environment:
  sdk: '>=3.4.0 <3.0.0'

dependencies:
  ixp_runtime: ^1.2.0
  logging: ^1.2.0
  xml: ^4.4.0

dev_dependencies:
  build_runner: ^2.4.11
  build_test: ^2.2.2
  instant_xml_parser: ^1.2.0
  test: ^1.25.8
```

### Generate your parser from the command line:

```sh
dart run build_runner build  --delete-conflicting-outputs
```
you can also watch the source files:

```sh
dart run build_runner watch  --delete-conflicting-outputs
```

### The XML

```xml
<addressBook>
  <ContactInfo email="alice@example.com">Birthday: April 1</ContactInfo>
  <ContactInfo email="bob@example.com">Birthday: Oct 31</ContactInfo>
</addressBook>');
```

### Parsing

```dart
import 'package:async/async.dart';
import 'package:example/example.dart';
import 'package:xml/xml_events.dart';

  StreamQueue<XmlEvent> _eventsFrom(String xml) => StreamQueue(Stream.value(xml)
      .toXmlEvents()
      .withParentEvents()
      .normalizeEvents()
      .flatten());

  final events = _eventsFrom(
          '<addressBook><ContactInfo email="alice@example.com">Birthday: April 1</ContactInfo><ContactInfo email="bob@example.com">Birthday: Oct 31</ContactInfo></addressBook>');
  final addressBook = await extractAddressBook(events);
```

## Features

* Attributes: Non-class fields read as attributes (with implicit or explicit conversion from String). To load a class from an attribute, ensure the class has a static method to instantiate from a String (e.g. ```static Foo parse(String s)```) and annotate field with ```@convert('Foo.parse')```.
* Text: Annotate a field with ```@textElement``` to read its XML text
* Classes: Annotate a class definition with ```@tag('qualified_name')``` to generate a parsing method
* Classes: Classes referenced from other classes automatically call that parsing method
* Subclasses: Subclass to implement alternate tags (e.g. if a field can take ```<a1>```, ```<a2>```, or ```<a3>```, give these a common superclass and use it)

## Limitations

This work started at Google, and is not an officially supported Google product.

* Assumes well-formed XML, and will ignore unknown tags/attributes/text in the input
  stream (but will log such).
* Declaration all has to be in one file (no cross-file references)
* Does nothing with XML comments, processing instructions, etc.

## Bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/sarahec/instant_xml_parser/issues

