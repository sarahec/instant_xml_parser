# Changelog

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

Bugfixes. Boring old bugfixes.

## 0.9.0

- First release to pub.dev.

## 0.9.1

- Bugfix for boolean attribute generation

## 0.10.0

- Added ```@custom``` annotation for attribute fields
