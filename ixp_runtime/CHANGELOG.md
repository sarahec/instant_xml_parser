# Runtime changelog

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

Renamed `runtime.dart` to `ixp_runtime.dart` to match 1.0.0 release. Annotated source to use Dart 2.10 for
easier development under newer SDKs.
