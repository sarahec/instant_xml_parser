# Runtime changelog

## 1.3.0

Better support for missing attributes. They can be nullable or have a fallback value when missing.

```dart
class Circuit {
  final bool verified; // required, `MissingAttribute` thrown if not found

  @ifMatches(r'(on|1)')
  @missingValue(false)
  final bool power;   // optional (by way of @missingValue), `false` if not found

  final bool? tested; // optional, `null` if not found
};
```

## 1.2.0

Set minimum SDK to 3.4. Removed `ancestor` extension and test as it's included in current `xml`.

## 0.9.0

- First release to pub.dev

## 0.10.0

- Bugfix for boolean attribute generation

## 0.10.1

- Added ```@custom``` annotation for attribute fields

## 0.11.0

Backport from null safety work. Near-100% test coverage.

**Breaking change** Replaced `events.find` returning an element or null with `events.seekTo` returning a boolean.
Follow up with `await eventrs.peek` or `await events.next` to get the found element.

## 0.12.0

Backported from null-safety.

## 1.0.0

**Null safety release** adapts the library for use with null-safe code. Same semantics as 0.11.0 and 0.12.0.

## 1.1.0

Major version upgrade to null-safe dependencies.

## 1.1.2

Adds `@constructor` annotation to select from multiple constructors.
