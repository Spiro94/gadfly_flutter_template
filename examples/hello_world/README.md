# hello_world

This example is to showcase what the template provides out of the box after code
changes, but we will walk through the structure of the application.

<!-- TOC -->

- [hello_world](#hello_world)
  - [High-level Overview of Directory Structure](#high-level-overview-of-directory-structure)
    - [Uncommented](#uncommented)
    - [Commented](#commented)
  - [Running this example](#running-this-example)
  - [User Flows](#user-flows)
    - [Sign Up Flow](#sign-up-flow)
    - [Sign In Flow](#sign-in-flow)
    - [Forgot Password Flow](#forgot-password-flow)
  - [Test Gallery](#test-gallery)

<!-- /TOC -->

## High-level Overview of Directory Structure

### Uncommented

```sh
├── .fvm
│   └── fvm_config.json
├── .github
│   └── workflows
│       ├── app_tests.yaml
│       └── supabase_tests.yaml
├── .vscode
│   ├── extensions.json
│   ├── launch.json
│   ├── settings.json
│   └── spellright.dict
├── Makefile
├── README.md
├── app
│   ├── analysis_options.yaml
│   ├── android
│   ├── assets
│   │   └── google_fonts
│   ├── dart_test.yaml
│   ├── ios
│   ├── lib
│   │   ├── app
│   │   ├── blocs
│   │   ├── effects
│   │   ├── i18n
│   │   ├── main
│   │   ├── pages
│   │   │   ├── authenticated
│   │   │   └── unauthenticated
│   │   ├── repositories
│   │   └── shared
│   ├── mkdocs.yml
│   ├── pubspec.yaml
│   ├── slang.yaml
│   ├── test
│   │   ├── flows
│   │   ├── flutter_test_config.dart
│   │   ├── gallery.css
│   │   └── util
│   └── web
├── docs
└── supabase
    ├── config.toml
    ├── functions
    ├── migrations
    ├── tests
    └── seed.sql
```

### Commented

```sh
# This is where we define the flutter version of this project using FVM (https://fvm.app/)
├── .fvm
# This is the FVM configuration file
│   └── fvm_config.json
# Our github workflows are defined in here
├── .github
│   └── workflows
# We have a workflow to run our app tests
│       ├── app_tests.yaml
# We have a workflow to run our database (i.e. supabase) tests
│       └── supabase_tests.yaml
# We use the VSCode editor and we can keep some settings and configurations in here.
├── .vscode
# This is where you can recommend extensions to be used when developing your application.
│   ├── extensions.json
# This is where you can define the different launch points of your application. 
# All of our entry points are files in `lib/main`.
│   ├── launch.json
# This is where you can set user settings. We need to set a few things here to ensure that FVM works properly.
# Any other settings is just personal preference.
│   ├── settings.json
#  A whitelist of words that would otherwise be considered incorrect.
│   └── spellright.dict
# The `Makefile` is a convenience file to make running CLI commands more convenient.
# See `docs/development.md` and `docs/testing.md` for further details
├── Makefile
# This file simply points to the `docs/` directory.
├── README.md
# The `app` directory is referring to the user-facing application. 
# This can be a mobile app or web app.
├── app
# Used to determine which linting options you want to be enforced.
# We start with `very_good_analysis` (https://pub.dev/packages/very_good_analysis)
# and then make modifications to it to fit our needs.
│   ├── analysis_options.yaml
# This directory can be kept if you are creating android applications, otherwise it is not needed and 
# can be safely deleted.
│   ├── android
# All of the assets for your application should be kept in this directory. This includes images, sounds, icons,
# fonts, etc.
│   ├── assets
# For fonts in particular, we can make use of the google_fonts package (https://pub.dev/packages/google_fonts)
# and provide the font files in a folder named `google_fonts`. Note, this needs to pair up correctly with the
# `pubspec.yaml` file.
│   │   └── google_fonts
# The Inter font is not required, it is simply an example font to demonstrate how to use google_fonts package.
│   │       ├── Inter-Black.ttf
│   │       ├── Inter-Bold.ttf
│   │       ├── Inter-ExtraBold.ttf
│   │       ├── Inter-ExtraLight.ttf
│   │       ├── Inter-Light.ttf
│   │       ├── Inter-Medium.ttf
│   │       ├── Inter-Regular.ttf
│   │       ├── Inter-SemiBold.ttf
│   │       └── Inter-Thin.ttf
# This file is here to add the tag of `golden` so when you run tests it doesn't complain. We need the tag
# `golden` because we are making use of golden_toolkit (https://pub.dev/packages/golden_toolkit) to 
# take screenshots.
│   ├── dart_test.yaml
# This directory can be kept if you are creating iOS applications, otherwise it is not needed and can be 
# safely deleted.
│   ├── ios
# This is where you can store all of your applications code (i.e. your Flutter code)
│   ├── lib
# This directory is where we can store everything that affects the entire application
│   │   ├── app
# We are using flutter_bloc (https://pub.dev/packages/flutter_bloc) for state management.
# Flutter bloc, at its core, makes use of events which can then update state. The bloc observer
# can listen for events and changes in state and then run callbacks. In this bloc observer we
# have set up the following:
# - logging to the console
# - wiring up remote redux devtools (https://pub.dev/packages/redux_remote_devtools). The other
#   parts required to wire this up can be found in `blocs/redux_remote_devtools.dart` and `main/configuration.dart`
│   │   │   ├── bloc_observer.dart
# The builder is the function that will create your application from scratch. 
# - All dependencies, in particular repositories, will be passed in as named parameters. This makes testing
#   easier because we can mock the repository layer here.
# - We are using slang (https://pub.dev/packages/slang) for internationalization, and there is
#   some setup that is done here to ensure that that works. The other parts can be found in `i18n`
#   and in `pubspec.yaml`
# - Normally we want to create our Blocs inside of the widget tree, but there is an exception
#   with the AuthBloc. We create it outside of the widget tree because we need to know whether or
#   not we have a valid access token before determining which routes the user can see and
#   creating the widget tree in the first place.  In particular, the AuthBloc is used 
#   by auto_route's guards.
# - We also set up some navigation observers here. One for Sentry and one for Amplitude.
│   │   │   ├── builder.dart
# For routing we use auto_route (https://pub.dev/packages/auto_route).
# The biggest takeaway from this file is we have separate branches for 
# authenticated vs unauthenticated routes. We do not mix and match. 
# If you are unauthenticated, you belong to the `anon` branch. We have two route guards, 
# the AuthGuard and the UnauthGuard. This is what will prevent a user from being able 
# to access a branch of routes that it shouldn't have access to.
│   │   │   ├── router.dart
│   │   │   ├── router.gr.dart
# This directory keeps the theme of our application. The following files are not adequate to support a full
# theme, so you will need to update and add your own files accordingly.
│   │   │   ├── theme
# This file takes advantage of Flutter's built in color_scheme for Material 3.
│   │   │   │   ├── color_scheme.dart
# This file can be used for standardized spacings throughout the application. 
# This prevents the use of magic numbers sprinkled throughout your application. 
# This file also shows an example of how to make an extension on BuildContext. 
# By adding this extension, we can access our spacings using context
# (e.g. `context.spacings.medium`).
│   │   │   │   ├── spacings.dart
# This is where we aggregate all of the neighboring files and define our Theme. 
# This theme is used by `app/builder.dart`
│   │   │   │   ├── theme.dart
# You can define different styles for different typographies. This file simply takes advantage of the default
# Material 3 styles and updates the font family to be Inter.
│   │   │   │   └── typography.dart
# We don't actually want to define widgets here. We prefer to keep widgets close to their use
# case, which is normally the page or flow that they are supporting. If there are shared widgets
# across the application, do NOT put them here. Instead, favor `shared/widgets` directory instead.
│   │   │   └── widgets
│   │   │       └── listener
# The only reason this directory exists is to have a home for this one widget. This widget is used
# to listen to Supabase and run a callback when the authentication status of the user has changed.
# This listener is at the top-level of our application because we want to switch the user to 
#  and from the authenticated and unauthenticated routing branches.
│   │   │           └── subscribe_to_auth_change.dart
# We use flutter_bloc (https://pub.dev/packages/flutter_bloc) and nearly all of our 
# business logic is defined here. Each bloc will get its own directory and will always have the 
# same files inside of it: bloc.dart, event.dart, state.dart.
│   │   ├── blocs
# This is our AuthBloc. Its primary job is to indicated whether or not the user is 
# authenticated or unauthenticated. We use this bloc in conjunction with our routing to
# prevent users from having access to pages they shouldn't have access to.
│   │   │   ├── auth
│   │   │   │   ├── bloc.dart
│   │   │   │   ├── event.dart
│   │   │   │   ├── state.dart
│   │   │   │   └── state.g.dart
# Dart recently added sealed classes. This is a really nice feature because you can switch over an
# exhuastive list of classes, but for this to work, sealed classes need to be defined in the SAME
# file. We want to use sealed classes for our blocs, but we don't want to define all of our blocs
# in the same file because that would be too much for a single file. What we have opted for
# instead is to have a file where we define a 'base' version of all of our Blocs in a sealed
# class. Then we can subclass the base version of our blocs in a different folder / file. We still
# get the benefit of switching over the sealed base classes of our blocs, but we no longer have to define
# all of our blocs in the same file.
│   │   │   ├── base_blocs.dart
# When a user already has an account, they may have forgotten their password. This Bloc supports 
# the forgot password flow.
│   │   │   ├── forgot_password
│   │   │   │   ├── bloc.dart
│   │   │   │   ├── event.dart
│   │   │   │   ├── state.dart
│   │   │   │   └── state.g.dart
# We use redux_remote_devtools (https://pub.dev/packages/redux_remote_devtools) to inspect all of our Bloc's
# state. Now this tool wasn't built with flutter_bloc in mind, so this file is shoehorn to make it work.
# In particular, we are taking advantage of the sealed base classes of our Blocs to construct a single state
# store that can then be utilized by redux remote detools. This may sound like a lot of setup to get this tool
# to work, but it is invaluable during development to quickly see the ENTIRE state of your application!
│   │   │   ├── redux_remote_devtools.dart
│   │   │   ├── redux_remote_devtools.g.dart
# This Bloc supports the SignIn page
│   │   │   ├── sign_in
│   │   │   │   ├── bloc.dart
│   │   │   │   ├── event.dart
│   │   │   │   ├── state.dart
│   │   │   │   └── state.g.dart
# This Bloc supports the SignUp page
│   │   │   └── sign_up
│   │   │       ├── bloc.dart
│   │   │       ├── event.dart
│   │   │       ├── state.dart
│   │   │       └── state.g.dart
# We highly recommend reading up on flutter_bloc, and the main concepts there include:
# - Blocs / Cubits
# - Repositories
# - Data Providers
# However, flutter_bloc doesn't have a solution for side-effects that are NOT hidden behind a repository layer.
# There will be side-effects in the widget tree such as playing audio, knowing the current time, 
# using shared preferences, etc. For these kinds of side-effects, that you need to make use of inside of the
# view layer, we provide "effects".  The reason we want to provide effects is so we can mock them when we test.
# All of these effect providers will be passed into the root of our application in the `builder.dart` file.
│   │   ├── effects
# The supabase_flutter package (https://pub.dev/packages/supabase_flutter) provides a way to listen to 
# auth changes, but the listener needs to be disposed of! This means we can't simply use this listener inside
# of a bloc or repository because if we did, we wouldn't have a way to dispose of it. Since we can only dispose
# of things from the view layer, this is a great opportunity for providing an effect and still affording us an 
# opportunity to mock it in tests.
│   │   │   ├── auth_change
│   │   │   │   ├── effect.dart
│   │   │   │   └── provider.dart
# When we want to know the current time, we can use `DateTime.now()`; however, this doesn't play nicely 
# when writing tests. When we write tests, we'd prefer for everything to be reproducible and the result of
# `DateTime.now()` will keep changing. This is another opportunity to provide an effect that returns the
# current time, which means we can mock it in tests.
│   │   │   ├── now
│   │   │   │   ├── effect.dart
│   │   │   │   └── provider.dart
# This isn't used by this template, but it is included because it likely won't be long before you reach for
# shared_preferences (https://pub.dev/packages/shared_preferences)
│   │   │   └── shared_preferences
│   │   │       └── provider.dart
# We use slang (https://pub.dev/packages/slang) for internationalization. Slang allows you to define your texts
# in a yaml file, which we think is easier to read than an arb file.
│   │   ├── i18n
│   │   │   ├── translations.g.dart
│   │   │   └── translations.i18n.yaml
# This folder is called main because it includes the different entry points for your application.
│   │   ├── main
# This file is responsible for setting up everything we need to run `appBuilder` in `builder.dart`. We set up:
# - our logger
# - forwarding errors to Sentry
# - all of our providers and repositories
# - optionally remote redux devtools
# Special note: everything that happens in this file is NOT run when test. So if you want it to be included 
# for the sake of testing, you can put it in the body of the `appBuilder` function in `builder.dart`.
│   │   │   ├── bootstrap.dart
# Flutter doesn't have a great environment variable story. At the end of the day, Flutter can't read
# environment variables, and they eventually need to be placed in a file. There are ways to not commit
# those files to version control, but they are still accessible from users of the application. So we opt
# for convenience and put all of our environment variables into version control and inside of this file.
│   │   │   ├── configuration.dart
# This is an entry point for regular development.
│   │   │   ├── development.dart
# This is an entry point for development and you always want events sent to Sentry and Amplitude.
│   │   │   ├── development_and_send_events.dart
# This is an entry point for development and you also want to see the redux remote devtools. 
# This is the one we end up using most often.
│   │   │   ├── development_with_redux_devtools.dart
# This is the entry point for your production build.
│   │   │   └── production.dart
# We do not organize our application based on features. Instead we organize our application based on pages.
# The folder structure here is very standardized. We have our two routing branches: 
# authenticated and unauthenticated. Inside of each of those branches, we have directories representing pages.
# Each page directory will have a file called `page.dart`. Each page can have widgets and there are three
# flavors of widgets: dumb, connector, and listener.  
#  - A dumb widget only takes in data as arguments and does not depend on a Bloc directly (a lot of Flutter
#    provided widgets can be considered dumb widgets).
#  - A connector widget typically takes in no arguments and self-assembles its own data (usually from a Bloc
#    and then passes data to dumb widgets.
#  - A listener widget is where you can store all of your BlocListener widgets. BlocListeners are unique in
#    that they listen for Bloc states which can trigger a callback. This is a bit of an extension of your
#    business logic and we want to quarantine this logic and make it easy to find.
#  - If widgets are logically grouped together, we can organize them into a molecule.
│   │   ├── pages
# This is the authenticated branch of pages
│   │   │   ├── authenticated
# This is the home page directory
│   │   │   │   ├── home
# The `Home_Page` widget is defined here.
│   │   │   │   │   ├── page.dart
# Any widgets used inside of `Home_Page` should be defined in the widgets directory.
│   │   │   │   │   └── widgets
# We have two `connector` widgets on this page.
│   │   │   │   │       └── connector
# The naming convention is to use the page name followed by `C`, `D`, `L`, or `M` (depending on if the widget
# is a connector, dumb, listener, or molecule respectively) then an underscore followed by the widget name.
# So this widget would be named: `HomeC_AppBar``
│   │   │   │   │           ├── app_bar.dart
# This widget is named `HomeC_SignOutButton`
│   │   │   │   │           └── sign_out_button.dart
# This is the reset password page directory.
│   │   │   │   ├── reset_password
# The `ResetPassword_Page` widget is defined here.
│   │   │   │   │   ├── page.dart
│   │   │   │   │   └── widgets
│   │   │   │   │       └── connector
│   │   │   │   │           └── app_bar.dart
# This is the router for the authenticated branch of routes.
│   │   │   │   └── router.dart
# This is the unauthenticated branch of pages
│   │   │   └── unauthenticated
# This is the forgot flow directory. We sometimes use a flow directory because we have pages that happen 
# in a sequence. For this flow, we start on the forgot password page, then go to the 
# forgot password confirmation page.
│   │   │       ├── forgot_flow
# This is the forgot password page directory.
│   │   │       │   ├── forgot_password
│   │   │       │   │   ├── page.dart
│   │   │       │   │   └── widgets
│   │   │       │   │       ├── connector
│   │   │       │   │       │   ├── app_bar.dart
│   │   │       │   │       │   ├── email_text_field.dart
│   │   │       │   │       │   └── reset_password_button.dart
│   │   │       │   │       ├── listener
# This widget is named `ForgotPasswordL_OnForgotPasswordStatusChange`. Listener widgets are usually listening
# to Bloc state changes. In this instance, we are listening ot a state change from the ForgotPasswordBloc.
│   │   │       │   │       │   └── on_forgot_password_status_change.dart
│   │   │       │   │       └── molecule
# This widget is named `ForgotPasswordM_ResetPasswordForm`. Forms are a perfect candidate to be upgraded to a
# molecule widget. This is because each form field typically has a controller and a focus node and by having a
# molecule widget, we can have this widget be the location where all of the controllers and focus nodes are
# defined so they can easily have access to each other. This is particularly helpful when you want to hit `tab`
# and go to the next form field or hit `enter` to submit the form and have access to all of the form's content.
│   │   │       │   │           └── reset_password_form.dart
# This is the forgot password confirmation page directory.
│   │   │       │   ├── forgot_password_confirmation
│   │   │       │   │   ├── page.dart
│   │   │       │   │   └── widgets
│   │   │       │   │       ├── connector
│   │   │       │   │       │   ├── app_bar.dart
│   │   │       │   │       │   ├── resend_email_button.dart
│   │   │       │   │       │   └── subtitle_text.dart
│   │   │       │   │       └── listener
│   │   │       │   │           └── on_forgot_password_status_change.dart
# This is the router for the forgot flow of routes.
│   │   │       │   └── router.dart
# This is the router for the unauthenticated branch of routes.
│   │   │       ├── router.dart
# This is the sign in page directory.
│   │   │       ├── sign_in
│   │   │       │   ├── page.dart
│   │   │       │   └── widgets
│   │   │       │       ├── connector
│   │   │       │       │   ├── app_bar.dart
│   │   │       │       │   ├── email_text_field.dart
│   │   │       │       │   ├── forgot_password_link.dart
│   │   │       │       │   ├── password_text_field.dart
│   │   │       │       │   ├── redirect_to_sign_up_link.dart
│   │   │       │       │   └── sign_in_button.dart
│   │   │       │       ├── listener
│   │   │       │       │   └── on_sign_in_status_change.dart
│   │   │       │       └── molecule
│   │   │       │           └── sign_in_form.dart
# This is the sign up page directory.
│   │   │       └── sign_up
│   │   │           ├── page.dart
│   │   │           └── widgets
│   │   │               ├── connector
│   │   │               │   ├── app_bar.dart
│   │   │               │   ├── email_text_field.dart
│   │   │               │   ├── password_text_field.dart
│   │   │               │   └── sign_up_button.dart
│   │   │               └── molecule
│   │   │                   └── sign_up_form.dart
# When using flutter_bloc, we have a separation between Blocs, Repositories, and Data Providers. This directory 
# is where we store our repositories.
│   │   ├── repositories
# This is the AuthRepository which will interact with a SupabaseClient.
│   │   │   └── auth
│   │   │       └── repository.dart
# Some code needs to be shared across the application.
│   │   └── shared
# This is where common validators can be stored.
│   │       ├── validators.dart
# This is where shared widgets can be stored. Note we do NOT expect to see connector widgets here because those 
# typically do not take in arguments and are context specific, which doesn't make them a good candidate to be
# shared.
│   │       └── widgets
│   │           ├── dumb
│   │           │   ├── app_bar.dart
│   │           │   └── button.dart
│   │           └── listener
│   │               └── on_auth_status_change.dart
# When we write our tests and run `make screenshots_update`, we are creating a gallery that can be served by 
# Mkdocs (https://www.mkdocs.org/). This is the configuration file for MkDocs to support that gallery.
│   ├── mkdocs.yml
# This is the standard configuration file for a flutter application, which includes our dependencies and
# assets, etc.
│   ├── pubspec.yaml
# This is the configuration file for Slang, which we use for internationalization.
│   ├── slang.yaml
# This directory includes all of our application tests.
│   ├── test
# All of the tests for our views should be included in this directory. We want to take advantage of flow-based
# testing. By doing this we unlock the opportunity to create a test gallery where you can view screenshots
# of all the user's flows they may encounter. This gallery is very helpful when trying to understand the intent 
# of your application.
│   │   ├── flows
# Underneath the flows directory, we can organize our flows by epics and stories. This would be our
# unauthenticated epic.
│   │   │   └── unauthenticated
# And this would be a forgot password story. So we can define all of the flows associated with a forgot
# password in this file. It should include happy and sad paths through the flow.
│   │   │       ├── forgot_password_test.dart
│   │   │       ├── sign_in_test.dart
│   │   │       └── sign_up_test.dart
# When using flutter_test (https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html) it will look
# for this specifically named file if you have any custom setup you want to define.
│   │   ├── flutter_test_config.dart
# This is the css used by MkDocs for the test gallery. The test gallery can be viewed by running `make gallery`
# and going to `localhost:8000`
│   │   ├── gallery.css
# To create the flow-based tests, there are some utility functions to speed up the process. We define them here.
│   │   └── util
# This file is used to create a test-specific version of our appBuilder from `lib/app/builder.dart`.
│   │       ├── app_builder.dart
# As promised, we provide effects because we want to be able to mock or fake them in our tests. We can define 
# them here.
│   │       ├── fake
│   │       │   ├── auth_change_effect.dart
│   │       │   ├── now_effect.dart
│   │       │   └── supabase_user.dart
# We define a utility function to setup our flow tests
│   │       ├── flow_config.dart
# The MockedApp has two functions:
# 1) it has a reference to our test-specific appBuilder function
# 2) it mocks all of our repositories and effects
│   │       ├── mocked_app.dart
# We defined a bloc_observer for our application, but we can change the behavior when we are writing tests.
# - We can keep track our analytic events in a list (instead of sending them to Amplitude)
# - We can keep track of our logs in a list (instead of printing them to the console)
│   │       ├── test_bloc_observer.dart
# A file to export the other utility files. 
│   │       ├── util.dart
# Because we are doing flow-based testing, we need a way to warp the user to specific spots in the application
# and then start testing from that point forward. This directory is where we can define how to warp a user to a
# specific spot.
│   │       └── warp
│   │           ├── to_forgot_password.dart
│   │           ├── to_forgot_password_confirmation.dart
│   │           ├── to_home.dart
│   │           └── to_sign_up.dart
# This directory is used if our application is targeting web.
│   └── web
# Our docs
├── docs
│   ├── development.md
│   ├── development_setup.md
│   └── testing.md
# We are using Supabase and this is where all of our backend / database code lives.
└── supabase
# We can run Supabase locally and this is the configuration file for doing so. Note: to run supabase locally
# you need the supabase_cli and docker.
    ├── config.toml
# This is where Edge Functions (https://supabase.com/docs/guides/functions) are defined. These are similar to
# AWS's Lambdas, and they can be triggered by a database change or by a webhook.
    ├── functions
# This is where your database migrations are kept.
    ├── migrations
# This is where your database tests are written. They can be run with `supabase test db`
    ├── tests
# When you run Supabase locally, you can seed the database with the contents of this file.
    └── seed.sql
```

## Running this example

1. Follow all the instructions in `docs/development_setup.md`. If you are using
   web, be sure to copy the snippet into your index.html file to use Amplitude!

2. Go to `lib/main/configurations.dart` and replace all the `CHANGE ME` texts
   with your credentials.

   For the **development** builds use these:
   - Supabase: run `supabase start` in a terminal, then find the `API URL` and
     the `anon key` in the printout.
   - Amplitude: N/A
   - Sentry: N/A

   For the **production** build use these:
   - ![Supabase credentials](readme_images/supabase_credentials.png?raw=true)
   - ![Amplitude credentials](readme_images/amplitude_credentials.png?raw=true)
   - ![Sentry DSN](readme_images/sentry_dsn.png?raw=true)
     ![Sentry environment](readme_images/sentry_environment.png?raw=true)

3. In your Supabase project, make sure to turn off email confirmations.

   ![turn off emails](readme_images/update_email_auth_provider.png?raw=true)

4. Run the following commands in order:
   - `make flutter_clean`
   - `make flutter_get`
   - `make slang_build`
   - `make runner_build`
   - `supabase start` (if this doesn't work, make sure Docker is running and
     that you have linked your project)

5. Run `make redux_devtools_server`, then go to a browser an go to
   [localhost:8001](http://localhost:8001). (When you start the application and
   you only see a blank screen, it is likely because you never did this step).

   ![Redux remote devtools](readme_images/redux_remote_devtools_start.png?raw=true)

6. In VSCode, open the _Run and Debug_ tab and select `development w/ devtools`.
   (If you don't see this option, open up VSCode from this directory instead of
   from gadfly_flutter_template's root directory)

## User Flows

If you successfully started the application, you should be able to go through
three user flows:

1. sign up flow
2. sign in flow
3. forgot password flow

### Sign Up Flow

![signup1](readme_images/signup1.png?raw=true)

![signup2](readme_images/signup2.png?raw=true)

### Sign In Flow

![signin1](readme_images/signin1.png?raw=true)

![signin2](readme_images/signin2.png?raw=true)

### Forgot Password Flow

![forgot_password1](readme_images/forgot_password1.png?raw=true)

![forgot_password2](readme_images/forgot_password2.png?raw=true)

![forgot_password3](readme_images/forgot_password3.png?raw=true)

![forgot_password4](readme_images/forgot_password4.png?raw=true)

![forgot_password5](readme_images/forgot_password5.png?raw=true)

![forgot_password6](readme_images/forgot_password6.png?raw=true)

![forgot_password7](readme_images/forgot_password7.png?raw=true)

## Test Gallery

The screenshots in the user flows above were taken manually, which is quite
cumbersome. However, since we are writing flow-based tests, we can take
advantage of the golden_toolkit to take screenshots for us and display them in a
gallery.

First, update the screenshots that are created by our tests:

```sh
make screenshots_update
```

Then serve up the gallery of screenshots:

```sh
make gallery
```

Then navigate to [localhost:8000](http://localhost:8000). You should see
something like the following:

![test gallery](readme_images/test_gallery.png?raw=true)
