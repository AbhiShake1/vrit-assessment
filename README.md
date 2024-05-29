# Vrit Photos

## About
this project uses a philosophically-bent version of clean-code architecture as data does not need to be cached and there can only be unidirectional communication (hence, business logig can directly consume service). this project also uses flutter hooks which makes the build method impure, but reduces a lot of boilerplate for handling local states, playing with widget lifecycle, reacting to/validating state update (or reducing the result), and so on. hooks has also been used to debounce search values in this project. hooks have been used inside build method to segregate and perform special operations (such as memoizing), so that the traditional BLoC layer can also be removed if state isnt shared).

## Development 🚀

> :warning: **You need to have dart v3.3 or higher**: This project utilizes extension types

This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```
---

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

