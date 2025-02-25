# Application Dependencies

This document details the flutter packages that we use.

## [auto_route](https://pub.dev/packages/auto_route)

We use auto_route for navigation. This package takes advantage of Navigator 2.0. We prefer it to alternatives like go_router because it plays nicer with bloc, and also seems to be less buggy.

## [auto_route_generator](https://pub.dev/packages/auto_route_generator) _(dev_dependency)_

Code generation for auto_route.

## [bloc_concurrency](https://pub.dev/packages/bloc_concurrency)

We use bloc_concurrency as a companion to flutter_bloc. When defining how events are handled by a bloc, we can use this package to help us succinctly define the type of concurrency:

- **concurrent**: Process events concurrently.
- **droppable**: Process only one event and ignore (drop) any new events until the current event is done.
- **restartable**: Process only one event by cancelling any pending events and processing the new event immediately.
- **sequential**: Process events one at a time by maintaining a queue of added events and processing the events sequentially.

The default concurrency that is used by bloc is concurrent. However, while this is more performant, we prefer a default of sequential, because it is easier to reason about. We can make it concurrent in specific instances where we need performance guarantees.

## bloc_devtools_extension _(dev_dependency)_

This is an extension that lives in flutter devtools. This extension is to display the bloc state after every handled bloc event. This is meant to be used during development.

## [build_runner](https://pub.dev/packages/build_runner) _(dev_dependency)_

This package is required for other packages to perform code generation.

## [collection](https://pub.dev/packages/collection)

We use collection as a utility package to make working with iterable data types (such as List, Set, etc.) easier. In particular, we can handle nullable values more gracefully with methods like `firstWhereOrNull`.

## [email_validator](https://pub.dev/packages/email_validator)

We use email_validator to validate a a user's email during sign in and sign up.

## [equatable](https://pub.dev/packages/equatable)

In dart, by default, objects are considered equal if they are the same instance. However, we often will be concerned with if objects possess the same data, and if they do, we want to consider them equal. That is where equatable comes in. It will override the definition of equality for us so that it is based on data equality.

This is particularly useful when using bloc because we want our bloc state and our models to be equatable based on their data.

We are not used the freezed package because we find that its code generation grinds to a halt when a project grows in size.

## flow_test _(dev_dependency)_

This is a testing library that focuses on testing user flows. The flow_tests produce screenshot images of every step in each flow, and they can be viewed in the Test Gallery.

## [flutter_bloc](https://pub.dev/packages/flutter_bloc)

We use flutter_bloc for state management. We prefer it to alternatives like Riverpod, because we want event-driven state changes. Having events helps us with debugging, testing, and analytics.

## [golden_toolkit](https://github.com/eBay/flutter_glove_box/) _(dev_dependency)_

We use golden_toolkit to create a gallery of test images using flow_test.

This package has been discontinued and we should move away from it when possible.

## [json_annotation](https://pub.dev/packages/json_annotation)

We use json_annotation to annotate our classes to make them json serializable.

## [json_serializable](https://pub.dev/packages/json_serializable) _(dev_dependency)_

Code generation for json_annotation.

## [logging](https://pub.dev/packages/logging)

We use logging to log.  We prefer using this package because you can write to multiple places, like to Sentry or standard out, etc.

## [mixpanel_flutter](https://pub.dev/packages/mixpanel_flutter)

We use mixpanel_flutter to track user analytics.

## [mocktail](https://pub.dev/packages/mocktail) _(dev_dependency)_

We use mocktail for testing. This helps us mock a class an change the response of its methods. We prefer this package to mockito. One of the main reasons is that mockito tries to do too much for you. It will stub out and mock all of your methods by default. However, we don't prefer this behavior, we want all methods that aren't mocked to fail so that we have a signal to mock those methods.

## [recase](https://pub.dev/packages/recase)

We use recase to change the naming convention of something. For example from FooBar (i.e. PascalCase) to foo_bar (i.e. snake_case).

## [sentry_flutter](https://pub.dev/packages/sentry_flutter)

We use sentry_flutter for error reporting.

## [sentry_logging](https://pub.dev/packages/sentry_logging)

We use sentry_logging to send and logs that are above warning to Sentry.

## [shadcn_flutter](https://pub.dev/packages/shadcn_flutter)

We use this package as a component library. When working with designers, they can roughly use shadcn in Figma and that will be a close approximation of what this library offers. Flutter has several other shadcn ports, but this one feels the most complete, despite not having the most github stars.

## [slang_flutter](https://pub.dev/packages/slang_flutter)

We use slang_flutter for internationalization. We prefer using this package over arb files because we can organize our strings in a yaml file.

## [slang](https://pub.dev/packages/slang) _(dev_dependency)_

Code generation for slang_flutter.

## [supabase_flutter](https://pub.dev/packages/supabase_flutter)

We use supabase_flutter to interact with our [Supabase](https://supabase.com/) backend.

## [uuid](https://pub.dev/packages/uuid)

We use uuid to create UUIDs.

## [very_good_analysis](https://pub.dev/packages/very_good_analysis) _(dev_dependency)_

We prefer using [Very Good Venture](https://verygood.ventures/)'s lint rules over the default ones that come with flutter. We can make adjustments to the lint rules in `app/analysis_options.yaml`.
