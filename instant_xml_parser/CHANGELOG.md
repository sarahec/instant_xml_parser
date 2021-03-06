# Changelog

## 1.0.0+2
Text processing was (rightfully) throwing an exception when a text element was missing.
Now the generator suppresses the exception if the corresponding field is nullable.
## 1.0.0+1

Allows use with both 0.1x runtime and 1.x runtime

## 1.0.0

Now reads null-safe sources and emits null-safe parsers. Note that the generator
itself isn't null-safe yet due to unmigrated dependencies.

# 0.11.1+2

BAckport from null-safe version.

# 0.11.1+2

Set `use_null_safety` by default in `build.yaml`. You shouldn't change it for now.

# 0.11.1+1

Pubspec fix (generator should depend on latest runtime)

# 0.11.1

Added `use_null_safety` generator option. Preserves legacy behavior (attributes are
all optional) when `false`.

# 0.11.0

Backport from null safety work. Significantly better test coverage for the runtime,
and generated parser improvements.
## 0.10.0

- Added ```@custom``` annotation for attribute fields

## 0.9.1

- Bugfix for boolean attribute generation

## 0.9.0

- First release to pub.dev.
