# Walkthrough of Example

<!-- TOC -->

- [Walkthrough of Example](#walkthrough-of-example)
  - [Step 0: Create a new project to follow along](#step-0-create-a-new-project-to-follow-along)
  - [Step 1: Add a counts table to Supabase](#step-1-add-a-counts-table-to-supabase)
  - [Step 2: Add row-level security policies on your counts table](#step-2-add-row-level-security-policies-on-your-counts-table)
  - [Step 3: Add a migration file for creating the counts table and its policies](#step-3-add-a-migration-file-for-creating-the-counts-table-and-its-policies)
  - [Step 4: Add a trigger to insert a new row into the counts table when a user signs up](#step-4-add-a-trigger-to-insert-a-new-row-into-the-counts-table-when-a-user-signs-up)
  - [Step 5: Add a migration file for creating the trigger and function](#step-5-add-a-migration-file-for-creating-the-trigger-and-function)
  - [Step 6: Create a Count Repository](#step-6-create-a-count-repository)
  - [Step 7: Create a Count Bloc](#step-7-create-a-count-bloc)
  - [Step 8: Display the counter on the Home_Page](#step-8-display-the-counter-on-the-home_page)
  - [Step 9: Add flow-based tests for this flow](#step-9-add-flow-based-tests-for-this-flow)
  - [Step 10: Add database tests](#step-10-add-database-tests)

<!-- /TOC -->

## Step 0: Create a new project to follow along

If you want to follow along in a brand new project then run:

```sh
# From the root of the gadfly_flutter_template, run: 

./create_app.sh fvm flutter create row_level_security
```

Then open VSCode in that directory:

```sh
code projects/row_level_security
```

Next, make sure Docker is running then start up Supabase locally:

```sh
supabase start
```

You should see a printout similar to this:

```sh
Started supabase local development setup.

         API URL: http://localhost:54321
     GraphQL URL: http://localhost:54321/graphql/v1
          DB URL: postgresql://postgres:postgres@localhost:54322/postgres
      Studio URL: http://localhost:54323
    Inbucket URL: http://localhost:54324
      JWT secret: super-secret-jwt-token-with-at-least-32-characters-long
        anon key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
service_role key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.EGIM96RAZx35lJzdJsyH-qQwv8Hdp7fsn3W0YpN81IU
```

Follow the `Studio URL` link. This is a local instance of the Supabase Studio.
You can make edits to your database using this tool.

## Step 1: Add a `counts` table to Supabase

We need a place to store each user's current count. Follow these steps to create
a counts table.

![counts1](images/walkthrough_of_example/counts1.png?raw=true)

![counts2](images/walkthrough_of_example/counts2.png?raw=true)

![counts3](images/walkthrough_of_example/counts3.png?raw=true)

![counts4](images/walkthrough_of_example/counts4.png?raw=true)

![counts5](images/walkthrough_of_example/counts5.png?raw=true)

![counts6](images/walkthrough_of_example/counts6.png?raw=true)

## Step 2: Add row-level security policies on your counts table

We don't want to let users read or update counts that aren't theirs. To
accomplish this, we can restrict access by creating row-level security policies.

Add a SELECT policy.

![select_policy1](images/walkthrough_of_example/select_policy1.png?raw=true)

![select_policy2](images/walkthrough_of_example/select_policy2.png?raw=true)

![select_policy3](images/walkthrough_of_example/select_policy3.png?raw=true)

![select_policy4](images/walkthrough_of_example/select_policy4.png?raw=true)

![select_policy5](images/walkthrough_of_example/select_policy5.png?raw=true)

Add an UPDATE policy.

![update_policy1](images/walkthrough_of_example/update_policy1.png?raw=true)

![update_policy2](images/walkthrough_of_example/update_policy2.png?raw=true)

![update_policy3](images/walkthrough_of_example/update_policy3.png?raw=true)

## Step 3: Add a migration file for creating the counts table and its policies

To create a blank migration file, you can run:

```sh
supabase migration new create_counts_table_with_policies
```

There should be a new file in your `supabase/migrations` folder with the
specified name.

To see the unsaved changes you have made to your database, you can run:

```sh
supabase db diff
```

I get the following printout:

```sql
create table "public"."counts" (
    "user_id" uuid not null,
    "created_at" timestamp with time zone not null default now(),
    "count" bigint not null
);


alter table "public"."counts" enable row level security;

CREATE UNIQUE INDEX counts_pkey ON public.counts USING btree (user_id);

alter table "public"."counts" add constraint "counts_pkey" PRIMARY KEY using index "counts_pkey";

alter table "public"."counts" add constraint "counts_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."counts" validate constraint "counts_user_id_fkey";

create policy "Users can read their own data"
on "public"."counts"
as permissive
for select
to authenticated
using ((user_id = auth.uid()));


create policy "Users can update their own data"
on "public"."counts"
as permissive
for update
to authenticated
using ((user_id = auth.uid()))
with check ((user_id = auth.uid()));
```

Copy the diff into the migration file.

_Note: If we wanted to do this in a single step, we could have run this instead:
`supabase db diff | supabase migration new create_counts_table_with_policies`._

## Step 4: Add a trigger to insert a new row into the counts table when a user signs up

We don't want user's to create or delete their own rows in the public.counts
table. Instead, we can set up a trigger to do this automatically. This trigger
can be triggered when a user signs up. Here is the flow:

1. A user signs up.
2. A new row is inserted into the auth.users table.
3. A trigger reacts to a new row being inserted to the auth.users table and
   calls a function.
4. That function creates a new row in the public.counts table.

Let's first create the function that will insert a new row into the
public.counts table. This is the function that the trigger will end up calling.

![function1](images/walkthrough_of_example/function1.png?raw=true)

![function2](images/walkthrough_of_example/function2.png?raw=true)

![function3](images/walkthrough_of_example/function3.png?raw=true)

![function4](images/walkthrough_of_example/function4.png?raw=true)

Next, let's create the trigger that will call this function.

![trigger1](images/walkthrough_of_example/trigger1.png?raw=true)

![trigger2](images/walkthrough_of_example/trigger2.png?raw=true)

![trigger3](images/walkthrough_of_example/trigger3.png?raw=true)

## Step 5: Add a migration file for creating the trigger and function

Let's create our new migration file:

```sh
supabase migration new add_trigger_on_signup
```

By default, when we run `supabase db diff` it includes the `public` schema.
However, we added a trigger to the `auth` schema. So to be able to make sure we
see that change in our diff, we need to run the following:

```sh
supabse db diff --schema public,auth
```

You should see:

```sql
set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.on_signup_insert_count()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$BEGIN
  INSERT INTO public.counts (user_id, count)
  VALUES (new.id, 0);

  return new;
END;$function$
;


CREATE TRIGGER trigger_on_signup_insert_count AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION on_signup_insert_count();
```

Copy this into your migration file.

## Step 6: Create a Count Repository

We need to access the count from our application. Since we are using
flutter_bloc, we have a separation between repositories, blocs, and the view
layer. Let's start by creating a repository.

Go to `app/lib/repositories` and create a new directory called `count`.

```sh
cd app/lib/repositories

mkdir count
```

Then create a file in the `count` directory called `repository.dart`.

```sh
cd count

touch repository.dart
```

Copy the following into that file:

```dart
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CountRepository {
  CountRepository({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  final _log = Logger('CountRepository');

  String? get _currentUserId => _supabaseClient.auth.currentSession?.user.id;

  Future<int> getCount() async {
    _log.info('getCount');

    final response = await _supabaseClient
        .from('counts')
        .select<PostgrestMap>('count')
        .single();

    _log.info('getCount response: $response');

    return response['count'] as int;
  }

  Future<int> updateCount({
    required int newCount,
  }) async {
    _log.info('updateCount');

    final response = await _supabaseClient
        .from('counts')
        .update(
          {'count': newCount},
        )
        .eq(
          'user_id',
          _currentUserId,
        )
        .select<PostgrestMap>('count')
        .single();

    _log.info('updateCount response: $response');

    return response['count'] as int;
  }
}
```

Then go to `app/lib/app/builder.dart` and replace the entire contents of the
file with:

```dart
import 'dart:ui';
import 'package:amplitude_repository/amplitude_repository.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// ignore: depend_on_referenced_packages
import 'package:sentry_flutter/sentry_flutter.dart';
import '../blocs/auth/bloc.dart';
import '../blocs/auth/state.dart';
import '../effects/auth_change/provider.dart';
import '../effects/now/provider.dart';
import '../i18n/translations.g.dart';
import '../repositories/auth/repository.dart';
// ATTENTION 1/6
import '../repositories/count/repository.dart';
// ---
import 'router.dart';
import 'theme/theme.dart';
import 'widgets/listener/subscribe_to_auth_change.dart';

Future<Widget> appBuilder({
  required String? deepLinkOverride,
  required String? accessToken,
  required AmplitudeRepository amplitudeRepository,
  required AuthChangeEffectProvider authChangeEffectProvider,
  required NowEffectProvider nowEffectProvider,
  required AuthRepository authRepository,
  // ATTENTION 2/6
  required CountRepository countRepository,
  // ---
  Key? key,
}) async {
  LocaleSettings.setLocale(AppLocale.en);

  final authState = accessToken != null && accessToken.isNotEmpty
      ? AuthState(
          status: AuthStatus.authenticated,
          accessToken: accessToken,
        )
      : const AuthState(
          status: AuthStatus.unauthentcated,
          accessToken: null,
        );

  final authBloc = AuthBloc(
    authRepository: authRepository,
    initialState: authState,
  );

  return BlocProvider.value(
    value: authBloc,
    child: TranslationProvider(
      child: App(
        key: key,
        deepLinkOverride: deepLinkOverride,
        amplitudeRepository: amplitudeRepository,
        authChangeEffectProvider: authChangeEffectProvider,
        nowEffectProvider: nowEffectProvider,
        authBloc: authBloc,
        authRepository: authRepository,
        // ATTENTION 3/6
        countRepository: countRepository,
        // ---
      ),
    ),
  );
}

class App extends StatelessWidget {
  App({
    required this.deepLinkOverride,
    required this.amplitudeRepository,
    required this.authChangeEffectProvider,
    required this.nowEffectProvider,
    required AuthBloc authBloc,
    required this.authRepository,
    // ATTENTION 4/6
    required this.countRepository,
    // ---
    super.key,
  }) : _appRouter = AppRouter(authBloc: authBloc);

  final String? deepLinkOverride;
  final AmplitudeRepository amplitudeRepository;
  final AuthChangeEffectProvider authChangeEffectProvider;
  final NowEffectProvider nowEffectProvider;
  final AuthRepository authRepository;
  // ATTENTION 5/6
  final CountRepository countRepository;
  // --

  final AppRouter _appRouter;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      // Effects
      providers: [
        RepositoryProvider<AuthChangeEffectProvider>.value(
          value: authChangeEffectProvider,
        ),
        RepositoryProvider<NowEffectProvider>.value(
          value: nowEffectProvider,
        ),
      ],
      child: MultiRepositoryProvider(
        // Repositories
        providers: [
          RepositoryProvider<AmplitudeRepository>.value(
            value: amplitudeRepository,
          ),
          RepositoryProvider<AuthRepository>.value(
            value: authRepository,
          ),
          // ATTENTION 6/6
          RepositoryProvider<CountRepository>.value(
            value: countRepository,
          ),
          // ---
        ],
        child: AppL_SubscribeToAuthChange(
          child: MaterialApp.router(
            theme: appTheme,
            debugShowCheckedModeBanner: false,
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: TranslationProvider.of(context).flutterLocale,
            supportedLocales: AppLocaleUtils.supportedLocales,
            routeInformationParser: _appRouter.defaultRouteParser(
              includePrefixMatches: true,
            ),
            routerDelegate: AutoRouterDelegate(
              _appRouter,
              deepLinkBuilder: (deepLink) => deepLinkBuilder(
                authBloc: context.read<AuthBloc>(),
                deepLink: deepLink,
                deepLinkOverride: deepLinkOverride,
              ),
              navigatorObservers: () => [
                SentryNavigatorObserver(),
                AmplitudeRouteObserver(
                  amplitudeRepository: amplitudeRepository,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

Then go to `app/lib/main/bootstrap.dart` and replace the entire contents of the
file with:

```dart
import 'package:amplitude_repository/amplitude_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:sentry_repository/sentry_repository.dart';
import 'package:supabase_client_provider/supabase_client_provider.dart';
import '../app/bloc_observer.dart';
import '../app/builder.dart';
import '../blocs/redux_remote_devtools.dart';
import '../effects/auth_change/provider.dart';
import '../effects/now/provider.dart';
import '../repositories/auth/repository.dart';
// ATTENTION 1/3
import '../repositories/count/repository.dart';
// ---
import 'configuration.dart';

Future<void> bootstrap({required MainConfiguration configuration}) async {
  final log = Logger('bootstrap');

  Logger.root.level = configuration.logLevel;
  Logger.root.onRecord.listen((record) {
    debugPrint(
      '[${record.loggerName}] ${record.level.name}: ${record.message}',
    );
  });
  log.finest('logger set up');

  FlutterError.onError = (details) {
    log.severe(details.exceptionAsString(), details.exception, details.stack);
  };
  log.finest('flutter onError callback set up');

  if (configuration.useReduxDevtools) {
    await createReduxRemoteDevtoolsStore();
    log.finest('redux remote devtools started');
  }

  Future<void> _appRunner() async {
    WidgetsFlutterBinding.ensureInitialized();
    log.finest('ensure initialized');

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    log.finest('preferred orientations set');

    int? sessionId;

    final amplitudeRepository = AmplitudeRepository(
      configuration: configuration.amplitudeRepositoryConfiguration,
    );
    log.finer('amplitude repository created');
    await amplitudeRepository.init();
    log.finest('amplitude repository initialized');

    try {
      sessionId = await amplitudeRepository.amplitude?.getSessionId();
      log.info('amplitude repository set sessionId: $sessionId');
    } catch (_) {
      log.warning('Failed: amplitude repository set sessionId');
    }

    if (configuration.sentryRepositoryConfiguration != null) {
      if (sessionId != null) {
        SentryRepository.setSessionId(sessionId.toString());
        log.finest('sentry, session id set');
      }
    }

    Bloc.observer = AppBlocObserver();
    log.finer('bloc observer created');

    final nowEffectProvider = NowEffectProvider();
    log.finer('now effect provider created');

    final supabaseClientProvider = SupabaseClientProvider(
      config: configuration.supabaseClientProviderConfiguration,
    );
    log.finest('supabase client provider created');

    await supabaseClientProvider.init();
    log.finest('supabase client initialzed');

    final authRepository = AuthRepository(
      authCallbackUrlHostname: configuration
          .supabaseClientProviderConfiguration.authCallbackUrlHostname,
      supabaseClient: supabaseClientProvider.client,
    );
    log.finer('auth repository created');

    final authChangeEffectProvider = AuthChangeEffectProvider(
      supabaseClient: supabaseClientProvider.client,
    );
    log.finer('auth change effect provider created');

    // ATTENTION 2/3
    final countRepository = CountRepository(
      supabaseClient: supabaseClientProvider.client,
    );
    log.finer('count repository created');
    // ---

    runApp(
      await appBuilder(
        deepLinkOverride: null,
        accessToken:
            supabaseClientProvider.client.auth.currentSession?.accessToken,
        amplitudeRepository: amplitudeRepository,
        authChangeEffectProvider: authChangeEffectProvider,
        nowEffectProvider: nowEffectProvider,
        authRepository: authRepository,
        // ATTENTION 3/3
        countRepository: countRepository,
        // ---
      ),
    );
    log.info('app has started');
  }

  if (configuration.sentryRepositoryConfiguration != null) {
    final sentryRepository = SentryRepository(
      configuration: configuration.sentryRepositoryConfiguration!,
      appRunner: _appRunner,
    );
    log.finer('sentryRepository created');

    await sentryRepository.init();
    log.finest('sentryRepository initialized');
  } else {
    await _appRunner();
  }
}
```

Then go to `test/util/mocked_app` and replace the entire contents of the file
with:

```dart
import 'package:amplitude_repository/amplitude_repository.dart';
import 'package:flow_test/flow_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:row_level_security/effects/auth_change/provider.dart';
import 'package:row_level_security/effects/now/provider.dart';
import 'package:row_level_security/repositories/auth/repository.dart';
// ATTENTION 1/3
import 'package:row_level_security/repositories/count/repository.dart';
// ---

import 'app_builder.dart';

List<MockedApp> createdMockedApps({
  required bool hasAccessToken,
  required String? deepLinkOverride,
}) =>
    [
      MockedApp(
        key: const Key('app'),
        events: [],
        mocks: MocksContainer(),
        accessToken: hasAccessToken ? 'fakeAccessToken' : null,
        deepLinkOverride: deepLinkOverride,
      ),
    ];

class MockedApp extends FTMockedApp<MocksContainer> {
  MockedApp({
    required Key key,
    required super.events,
    required super.mocks,
    required String? accessToken,
    required String? deepLinkOverride,
  }) : super(
          appBuilder: () async => await testAppBuilder(
            key: key,
            mocks: mocks,
            accessToken: accessToken,
            deepLinkOverride: deepLinkOverride,
          ),
        );
}

class MocksContainer {
  final authChangeEffectProvider = MockAuthChangeEffectProvider();
  final nowEffectProvider = MockNowEffectProvider();

  final amplitudeRepository = MockAmplitudeRepository();
  final authRepository = MockAuthRepository();
  // ATTENTION 2/3
  final countRepository = MockCountRepository();
  // ---
}

class MockAuthChangeEffectProvider extends Mock
    implements AuthChangeEffectProvider {}

class MockNowEffectProvider extends Mock implements NowEffectProvider {}

class MockAmplitudeRepository extends Mock implements AmplitudeRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

// ATTENTION 3/3
class MockCountRepository extends Mock implements CountRepository {}
// ---
```

Then go to `test/util/app_builder_app` and replace the entire contents of the
file with:

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:row_level_security/app/builder.dart';

import 'mocked_app.dart';

FutureOr<Widget> testAppBuilder({
  required Key key,
  required String? accessToken,
  required String? deepLinkOverride,
  required MocksContainer mocks,
}) async {
  return await appBuilder(
    key: key,
    deepLinkOverride: deepLinkOverride,
    accessToken: accessToken,
    amplitudeRepository: mocks.amplitudeRepository,
    authChangeEffectProvider: mocks.authChangeEffectProvider,
    nowEffectProvider: mocks.nowEffectProvider,
    authRepository: mocks.authRepository,
    // ATTENTION 1/1
    countRepository: mocks.countRepository,
    // ---
  );
}
```

## Step 7: Create a Count Bloc

Now that we have our `CountRepository`, we can create a `CountBloc`.

Go to `app/lib/blocs` and create a new directory called `count`.

```sh
cd app/lib/blocs

mkdir count
```

Create three files inside the count directory:

```sh
cd count

touch state.dart
touch event.dart
touch bloc.dart
```

Copy the following into the `app/lib/blocs/count/state.dart` file:

```dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

enum CountStatus {
  idle,
  loading,
  error,
}

@JsonSerializable()
class CountState extends Equatable {
  const CountState({
    required this.status,
    required this.count,
  });

  final CountStatus status;
  final int count;

  CountState copyWith({
    CountStatus? status,
    int? count,
  }) {
    return CountState(
      status: status ?? this.status,
      count: count ?? this.count,
    );
  }

  @override
  List<Object?> get props => [
        status,
        count,
      ];

  // coverage:ignore-start
  factory CountState.fromJson(Map<String, dynamic> json) =>
      _$CountStateFromJson(json);

  Map<String, dynamic> toJson() => _$CountStateToJson(this);
  // coverage:ignore-end
}
```

Copy the following into the `app/lib/blocs/count/event.dart` file:

```dart
sealed class CountEvent {}

class CountEvent_Initialize extends CountEvent {}

class CountEvent_Increment extends CountEvent {}

class CountEvent_Decrement extends CountEvent {}
```

Copy the following into the `app/lib/blocs/base_blocs.dart` file:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth/event.dart';
import 'auth/state.dart';
// ATTENTION 1/2
import 'count/event.dart';
import 'count/state.dart';
// ---
import 'forgot_password/event.dart';
import 'forgot_password/state.dart';
import 'sign_in/event.dart';
import 'sign_in/state.dart';
import 'sign_up/event.dart';
import 'sign_up/state.dart';

sealed class AppBaseBloc<Event, State> extends Bloc<Event, State> {
  AppBaseBloc(super.initialState);
}

class AuthBaseBloc extends AppBaseBloc<AuthEvent, AuthState> {
  AuthBaseBloc(super.initialState);
}

class ForgotPasswordBaseBloc
    extends AppBaseBloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBaseBloc(super.initialState);
}

class SignInBaseBloc extends AppBaseBloc<SignInEvent, SignInState> {
  SignInBaseBloc(super.initialState);
}

class SignUpBaseBloc extends AppBaseBloc<SignUpEvent, SignUpState> {
  SignUpBaseBloc(super.initialState);
}

// ATTENTION 2/2
class CountBaseBloc extends AppBaseBloc<CountEvent, CountState> {
  CountBaseBloc(super.initialState);
}
// --
```

Copy the following into the `app/lib/blocs/count/bloc.dart` file:

```dart
import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/count/repository.dart';
import '../base_blocs.dart';
import 'event.dart';
import 'state.dart';

class CountBloc extends CountBaseBloc {
  CountBloc({
    required CountRepository countRepository,
  })  : _countRepository = countRepository,
        super(
          const CountState(status: CountStatus.idle, count: 0),
        ) {
    on<CountEvent_Initialize>(
      _onInitialize,
      transformer: sequential(),
    );
    on<CountEvent_Increment>(
      _onIncrement,
      transformer: sequential(),
    );
    on<CountEvent_Decrement>(
      _onDecrement,
      transformer: sequential(),
    );
  }

  final CountRepository _countRepository;

  Future<void> _onInitialize(
    CountEvent_Initialize event,
    Emitter<CountState> emit,
  ) async {
    emit(
      state.copyWith(status: CountStatus.loading),
    );

    try {
      final count = await _countRepository.getCount();
      emit(
        state.copyWith(count: count),
      );
    } catch (e) {
      emit(
        state.copyWith(status: CountStatus.error),
      );
    } finally {
      emit(
        state.copyWith(status: CountStatus.idle),
      );
    }
  }

  Future<void> _onIncrement(
    CountEvent_Increment event,
    Emitter<CountState> emit,
  ) async {
    emit(
      state.copyWith(status: CountStatus.loading),
    );

    try {
      final incrementedCount = await _countRepository.updateCount(
        newCount: state.count + 1,
      );
      emit(
        state.copyWith(count: incrementedCount),
      );
    } catch (e) {
      emit(
        state.copyWith(status: CountStatus.error),
      );
    } finally {
      emit(
        state.copyWith(status: CountStatus.idle),
      );
    }
  }

  Future<void> _onDecrement(
    CountEvent_Decrement event,
    Emitter<CountState> emit,
  ) async {
    emit(
      state.copyWith(status: CountStatus.loading),
    );

    try {
      final decrementedCount = await _countRepository.updateCount(
        newCount: state.count - 1,
      );
      emit(
        state.copyWith(count: decrementedCount),
      );
    } catch (e) {
      emit(
        state.copyWith(status: CountStatus.error),
      );
    } finally {
      emit(
        state.copyWith(status: CountStatus.idle),
      );
    }
  }
}
```

Copy the following into the `app/lib/blocs/redux_remote_devtools.dart` file:

```dart
// ignore_for_file: depend_on_referenced_packages
import 'dart:async';

import 'package:json_annotation/json_annotation.dart';
import 'package:redux/redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:redux_remote_devtools/redux_remote_devtools.dart';

import 'auth/state.dart';
import 'base_blocs.dart';
// ATTENTION 1/8
import 'count/state.dart';
// ---
import 'forgot_password/state.dart';
import 'sign_in/state.dart';
import 'sign_up/state.dart';

part 'redux_remote_devtools.g.dart';

DevToolsStore<DevtoolsDb>? remoteReduxDevtoolsStore;
DevtoolsDb devtoolsDb = const DevtoolsDb();

@JsonSerializable()
class DevtoolsDb {
  const DevtoolsDb({
    this.authState,
    this.forgotPasswordState,
    this.signInState,
    this.signUpState,
    // ATTENTION 2/8
    this.countState,
    // --
  });

  final AuthState? authState;
  final ForgotPasswordState? forgotPasswordState;
  final SignInState? signInState;
  final SignUpState? signUpState;
  // ATTENTION 3/8
  final CountState? countState;
  // --

  DevtoolsDb copyWith({
    AuthState? authState,
    bool clearAuthState = false,
    ForgotPasswordState? forgotPasswordState,
    bool clearForgotPasswordState = false,
    SignInState? signInState,
    bool clearSignInState = false,
    SignUpState? signUpState,
    bool clearSignUpState = false,
    // ATTENTION 4/8
    CountState? countState,
    bool clearCountState = false,
    // ---
  }) {
    return DevtoolsDb(
      authState: clearAuthState ? null : authState ?? this.authState,
      forgotPasswordState: clearForgotPasswordState
          ? null
          : forgotPasswordState ?? this.forgotPasswordState,
      signInState: clearSignInState ? null : signInState ?? this.signInState,
      signUpState: clearSignUpState ? null : signUpState ?? this.signUpState,
      // ATTENTION 5/8
      countState: clearCountState ? null : countState ?? this.countState,
      // --
    );
  }

  // coverage:ignore-start
  factory DevtoolsDb.fromJson(Map<String, dynamic> json) =>
      _$DevtoolsDbFromJson(json);

  Map<String, dynamic> toJson() => _$DevtoolsDbToJson(this);
  // coverage:ignore-end
}

void remoteReduxDevtoolsOnCreate({
  required AppBaseBloc<dynamic, dynamic> bloc,
}) {
  if (remoteReduxDevtoolsStore != null) {
    switch (bloc) {
      case AuthBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(authState: bloc.state);

      case ForgotPasswordBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(forgotPasswordState: bloc.state);

      case SignInBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(signInState: bloc.state);

      case SignUpBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(signUpState: bloc.state);

      // ATTENTION 6/8
      case CountBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(countState: bloc.state);
      // ---
    }

    remoteReduxDevtoolsStore?.dispatch('CreateBloc_${bloc.runtimeType}');
  }
}

void remoteReduxDevtoolsOnTransition({
  required AppBaseBloc<dynamic, dynamic> bloc,
  required dynamic state,
  required dynamic event,
}) {
  if (remoteReduxDevtoolsStore != null) {
    switch (bloc) {
      case AuthBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(authState: state as AuthState);

      case ForgotPasswordBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(
          forgotPasswordState: state as ForgotPasswordState,
        );

      case SignInBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(signInState: state as SignInState);

      case SignUpBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(signUpState: state as SignUpState);

      // ATTENTION 7/8
      case CountBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(countState: state as CountState);
      // ---
    }

    remoteReduxDevtoolsStore?.dispatch(event.runtimeType.toString());
  }
}

void remoteReduxDevtoolsOnClose({
  required AppBaseBloc<dynamic, dynamic> bloc,
}) {
  if (remoteReduxDevtoolsStore != null) {
    switch (bloc) {
      case AuthBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(clearAuthState: true);

      case ForgotPasswordBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(clearForgotPasswordState: true);

      case SignInBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(clearSignInState: true);

      case SignUpBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(clearSignUpState: true);

      // ATTENTION 8/8
      case CountBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(clearSignUpState: true);
      // ---
    }

    remoteReduxDevtoolsStore?.dispatch('DisposeBloc_${bloc.runtimeType}');
  }
}

Future<void> createReduxRemoteDevtoolsStore() async {
  final _devtools = RemoteDevToolsMiddleware<DevtoolsDb>('localhost:8001');

  await runZonedGuarded(
    () async {
      await _devtools.connect();
    },
    (_, __) {},
  );

  final store = DevToolsStore<DevtoolsDb>(
    (_, __) => devtoolsDb,
    initialState: devtoolsDb,
    middleware: <Middleware<DevtoolsDb>>[
      _devtools.call,
    ],
  );

  _devtools.store = store;
  remoteReduxDevtoolsStore = store;
}
```

Finally, run the following command from the root of this project:

```sh
make runner_build
```

## Step 8: Display the counter on the `Home_Page`

Now that we have our CountRepository and CountBloc wired up, let's create the
view layer for the counter.

First, let's copy the following into `app/lib/i18n/translations.i18n.yaml`:

```yaml
signIn:
  title: 'Sign In'
  form:
    email:
      placeholder: 'Email'
      error:
        invalid: 'Please enter a valid email address.'
    password:
      placeholder: 'Password'
  ctas:
    signIn: 'Sign In'
    error: 'Could not sign in.'
  forgotPassword(rich): '${tapHere(Forgot Password)}'
  newUserSignUp(rich): 'New User? ${tapHere(Sign Up)}'


signUp:
  title: 'Sign Up'
  form:
    email:
      placeholder: 'Email'
      error:
        invalid: 'Please enter a valid email address.'
    password:
      placeholder: 'Password'
      helpText(rich): '${tapHere(See password criteria)}'
      error: 
        invalid: 'Minimum 8 characters, upper and lower case, with at least one special character.'
  ctas:
    signUp: 'Sign Up'
    error: 'Could not sign up.'


forgotPassword:
  title: 'Forgot Password'
  form:
    email:
      placeholder: 'Email'
      error: 
        invalid: 'Please enter a valid email address.'
  ctas:
    resetPassword: 'Reset Password'
    error: 'Could not reset password.'


forgotPasswordConfirmation:
  title: 'Check your inbox.'
  subtitle: 'If this email is valid, you should receive a log-in link within a few minutes.'
  ctas:
    resendEmail: 'Re-send Email'
    emailResent: 'Email resent.'
    error: 'Could not resend email.'


home:
  title: 'Home'
# ATTENTION 1/1
  increment: 'Increment'
  decrement: 'Decrement'
# ---


resetPassword:
  title: 'Reset Password'
```

Then, to recreate our internationalization file, let's run:

```sh
make slang_build
```

Let's create the following files:

```sh
cd app/lib/pages/authenticated/home/widgets/connector

touch counter_text.dart
touch decrement_button.dart
touch increment_button.dart
```

Copy the following into `counter_text.dart`:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/count/bloc.dart';

class HomeC_CounterText extends StatelessWidget {
  const HomeC_CounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final countBloc = context.watch<CountBloc>();
    final count = countBloc.state.count;

    return Text(count.toString());
  }
}
```

Copy the following into `decrement_button.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/count/bloc.dart';
import '../../../../../blocs/count/event.dart';
import '../../../../../i18n/translations.g.dart';

class HomeC_DecrementButton extends StatelessWidget {
  const HomeC_DecrementButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Text(
        context.t.home.decrement,
      ),
      onPressed: () {
        final countBloc = context.read<CountBloc>();
        countBloc.add(CountEvent_Decrement());
      },
    );
  }
}
```

Copy the following into `increment_button.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/count/bloc.dart';
import '../../../../../blocs/count/event.dart';
import '../../../../../i18n/translations.g.dart';

class HomeC_IncrementButton extends StatelessWidget {
  const HomeC_IncrementButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Text(
        context.t.home.increment,
      ),
      onPressed: () {
        final countBloc = context.read<CountBloc>();
        countBloc.add(CountEvent_Increment());
      },
    );
  }
}
```

Copy the following into `app/lib/pages/authenticated/home/page.dart`:

```dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/theme/theme.dart';
import '../../../blocs/count/bloc.dart';
import '../../../repositories/count/repository.dart';
import 'widgets/connector/app_bar.dart';
// ATTENTION 1/3
import 'widgets/connector/counter_text.dart';
import 'widgets/connector/decrement_button.dart';
import 'widgets/connector/increment_button.dart';
// ---
import 'widgets/connector/sign_out_button.dart';

@RoutePage()
class Home_Page extends StatelessWidget {
  const Home_Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // ATTENTION 2/3
    return BlocProvider(
      create: (context) {
        return CountBloc(countRepository: context.read<CountRepository>())
          ..add(CountEvent_Initialize());
      },
      child: const Home_Scaffold(),
    );
    // ---
  }
}

class Home_Scaffold extends StatelessWidget {
  const Home_Scaffold({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeC_AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(context.spacings.large),
          child: Column(
            children: [
              // ATTENTION 3/3
              Row(
                children: [
                  const HomeC_DecrementButton(),
                  SizedBox(
                    width: context.spacings.small,
                  ),
                  const HomeC_CounterText(),
                  SizedBox(
                    width: context.spacings.small,
                  ),
                  const HomeC_IncrementButton(),
                ],
              ),
              SizedBox(
                height: context.spacings.medium,
              ),
              // ---
              const HomeC_SignOutButton(),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Step 9: Add flow-based tests for this flow

Before we add a new test file, we need to update the existing tests to make them
pass.

Copy the following into `test/flows/unauthenticated/sign_in_test.dart`:

```dart
import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;

import 'package:loading_indicator/loading_indicator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:row_level_security/blocs/auth/event.dart';
// ATTENTION 1/4
import 'package:row_level_security/blocs/count/event.dart';
// --
import 'package:row_level_security/blocs/sign_in/event.dart';
import 'package:row_level_security/pages/authenticated/home/page.dart';
import 'package:row_level_security/pages/unauthenticated/sign_in/page.dart';
import 'package:row_level_security/pages/unauthenticated/sign_in/widgets/connector/email_text_field.dart';
import 'package:row_level_security/pages/unauthenticated/sign_in/widgets/connector/password_text_field.dart';
import 'package:row_level_security/pages/unauthenticated/sign_in/widgets/connector/sign_in_button.dart';
import 'package:row_level_security/shared/widgets/dumb/button.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../util/fake/auth_change_effect.dart';
import '../../util/fake/supabase_user.dart';
import '../../util/util.dart';

void main() {
  final baseDescriptions = [
    FTDescription(
      descriptionType: 'EPIC',
      shortDescription: 'unauthenticated',
      description:
          '''As a user, I need to be able to interact with the appication when I am unauthenticated.''',
    ),
    FTDescription(
      descriptionType: 'STORY',
      shortDescription: 'sign_in',
      description:
          '''As a user, I should be able to sign in to the application, so that I can use it.''',
      atScreenshotsLevel: true,
    ),
  ];

  group('Happy Path', () {
    final happyPathDescription = FTDescription(
      descriptionType: 'PATH',
      shortDescription: 'happy_path',
      description: '''Happy Path: Signing in is successful''',
    );

    flowTest(
      'HP1',
      config: createFlowConfig(
        hasAccessToken: false,
      ),
      descriptions: [
        ...baseDescriptions,
        happyPathDescription,
        FTDescription(
          descriptionType: 'AC',
          shortDescription: 'tapping_inputs',
          description:
              '''There are two ways to fill out the form. This covers manually tapping into each input.''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: (arrange) async {
            final fakeAuthChangeEffect = FakeAuthChangeEffect();
            when(() => arrange.mocks.authChangeEffectProvider.getEffect())
                .thenAnswer(
              (invocation) => fakeAuthChangeEffect,
            );

            arrange.extras['fakeAuthChangeEffect'] = fakeAuthChangeEffect;
          },
        );

        await tester.screenshot(
          description: 'initial state',
          expectations: (expectations) {
            expectations.expect(
              find.byType(SignIn_Page),
              findsOneWidget,
              reason: 'Should be on the SignIn page',
            );
          },
          expectedEvents: [
            'Page: SignIn',
          ],
        );

        await tester.screenshot(
          description: 'enter email',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignInC_EmailTextField),
              'foo@example.com',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'enter password',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignInC_PasswordTextField),
              'Pass123!',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'tap submit button (pump half)',
          arrangeBeforeActions: (arrange) {
            when(
              () => arrange.mocks.authRepository.signIn(
                email: any(named: 'email'),
                password: any(named: 'password'),
              ),
            ).thenAnswer((invocation) async {
              await Future<void>.delayed(const Duration(seconds: 500));
              final fakeAuthChangeEffect = arrange
                  .extras['fakeAuthChangeEffect'] as FakeAuthChangeEffect;
              fakeAuthChangeEffect.streamController?.add(
                supabase.AuthState(
                  supabase.AuthChangeEvent.signedIn,
                  supabase.Session(
                    accessToken: 'fakeAccessToken',
                    tokenType: '',
                    user: FakeSupabaseUser(),
                  ),
                ),
              );
              return;
            });
          },
          actions: (actions) async {
            await actions.userAction.tap(find.byType(SignInC_SignInButton));
            await actions.testerAction.pump(const Duration(milliseconds: 250));
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(LoadingIndicator),
              findsOneWidget,
              reason: 'Should see a loading indicator',
            );
            expectations.expect(
              find.byType(Home_Page),
              findsNothing,
              reason: 'Should not be on the Home page yet',
            );
          },
          expectedEvents: [
            SignInEvent_SignIn,
          ],
        );

        await tester.screenshot(
          description: 'tap submit button (pump rest)',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(Home_Page),
              findsOneWidget,
              reason: 'Should be on the Home page',
            );
          },
          expectedEvents: [
            'INFO: [auth_change_subscription] signedIn',
            AuthEvent_AccessTokenAdded,
            'Page: Home',
            // ATTENTION 2/4
            CountEvent_Initialize,
            // --
          ],
        );
      },
    );

    flowTest(
      'HP2',
      config: createFlowConfig(hasAccessToken: false),
      descriptions: [
        ...baseDescriptions,
        happyPathDescription,
        FTDescription(
          descriptionType: 'AC',
          shortDescription: 'pressing_enter',
          description:
              '''There are two ways to fill out the form. This covers pressing enter to jump to the next input.''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: (arrange) async {
            final fakeAuthChangeEffect = FakeAuthChangeEffect();
            when(() => arrange.mocks.authChangeEffectProvider.getEffect())
                .thenAnswer(
              (invocation) => fakeAuthChangeEffect,
            );
            arrange.extras['fakeAuthChangeEffect'] = fakeAuthChangeEffect;
          },
        );

        await tester.screenshot(
          description: 'initial state',
          expectations: (expectations) {
            expectations.expect(
              find.byType(SignIn_Page),
              findsOneWidget,
              reason: 'Should be on the SignIn page',
            );
          },
          expectedEvents: [
            'Page: SignIn',
          ],
        );

        await tester.screenshot(
          description: 'enter email',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignInC_EmailTextField),
              'foo@example.com',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'press enter',
          actions: (actions) async {
            await actions.userAction.testTextInputReceiveNext();
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'enter password',
          actions: (actions) async {
            await actions.userAction.testTextInputEnterText('password');
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'press enter (pump half)',
          arrangeBeforeActions: (arrange) {
            when(
              () => arrange.mocks.authRepository.signIn(
                email: any(named: 'email'),
                password: any(named: 'password'),
              ),
            ).thenAnswer((invocation) async {
              await Future<void>.delayed(const Duration(seconds: 500));
              final fakeAuthChangeEffect = arrange
                  .extras['fakeAuthChangeEffect'] as FakeAuthChangeEffect;
              fakeAuthChangeEffect.streamController?.add(
                supabase.AuthState(
                  supabase.AuthChangeEvent.signedIn,
                  supabase.Session(
                    accessToken: 'fakeAccessToken',
                    tokenType: '',
                    user: FakeSupabaseUser(),
                  ),
                ),
              );

              return;
            });
          },
          actions: (actions) async {
            await actions.userAction.testTextInputReceiveDone();
            await actions.testerAction.pump(const Duration(milliseconds: 250));
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(LoadingIndicator),
              findsOneWidget,
              reason: 'Should see a loading indicator',
            );
            expectations.expect(
              find.byType(Home_Page),
              findsNothing,
              reason: 'Should not be on the Home page yet',
            );
          },
          expectedEvents: [
            SignInEvent_SignIn,
          ],
        );

        await tester.screenshot(
          description: 'press enter (pump rest)',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(Home_Page),
              findsOneWidget,
              reason: 'Should be on the Home page',
            );
          },
          expectedEvents: [
            'INFO: [auth_change_subscription] signedIn',
            AuthEvent_AccessTokenAdded,
            'Page: Home',
            // ATTENTION 3/4
            CountEvent_Initialize,
            // --
          ],
        );
      },
    );

    flowTest(
      'HP3',
      config: createFlowConfig(hasAccessToken: true),
      descriptions: [
        ...baseDescriptions,
        happyPathDescription,
        FTDescription(
          descriptionType: 'AC',
          shortDescription: 'already_have_token',
          description:
              '''As a user, if I already have an auth token, I should not see the SignIn page and should go straight to the Home page.''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: (arrange) async {
            final fakeAuthChangeEffect = FakeAuthChangeEffect();
            when(() => arrange.mocks.authChangeEffectProvider.getEffect())
                .thenAnswer(
              (invocation) => fakeAuthChangeEffect,
            );
          },
        );

        await tester.screenshot(
          description: 'initial state',
          actions: (actions) async {
            await actions.testerAction.pump();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(Home_Page),
              findsOneWidget,
              reason:
                  '''Should be on the Home page because we have an accessToken in local storage''',
            );
          },
          expectedEvents: [
            'Page: Home',
            // ATTENTION 4/4
            CountEvent_Initialize,
            // --
          ],
        );
      },
    );
  });

  group('Sad Path', () {
    final sadPathDescription = FTDescription(
      descriptionType: 'PATH',
      shortDescription: 'sad_path',
      description: '''Sad Path: Signing in is not successful''',
    );

    flowTest(
      'SP1',
      config: createFlowConfig(hasAccessToken: false),
      descriptions: [
        ...baseDescriptions,
        sadPathDescription,
        FTDescription(
          descriptionType: 'AC',
          shortDescription: 'empty_inputs',
          description:
              '''If either of the inputs are empty, should not be able to tap the sign in button''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: (arrange) async {
            final fakeAuthChangeEffect = FakeAuthChangeEffect();
            when(() => arrange.mocks.authChangeEffectProvider.getEffect())
                .thenAnswer(
              (invocation) => fakeAuthChangeEffect,
            );
          },
        );

        await tester.screenshot(
          description: 'initial state',
          expectations: (expectations) {
            expectations.expect(
              find.byType(SignIn_Page),
              findsOneWidget,
              reason: 'Should be on the SignIn page',
            );
          },
          expectedEvents: [
            'Page: SignIn',
          ],
        );

        await tester.screenshot(
          description: 'tap submit button',
          actions: (actions) async {
            await actions.userAction.tap(
              find.descendant(
                of: find.byType(SignInC_SignInButton),
                matching: find.byWidgetPredicate((widget) {
                  if (widget is SharedD_Button) {
                    return widget.status == SharedD_Button_Status.disabled;
                  }
                  return false;
                }),
              ),
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(SignIn_Page),
              findsOneWidget,
              reason: 'Should still be on SignIn page',
            );
          },
          expectedEvents: [],
        );
      },
    );

    flowTest(
      'SP2',
      config: createFlowConfig(hasAccessToken: false),
      descriptions: [
        ...baseDescriptions,
        sadPathDescription,
        FTDescription(
          descriptionType: 'AC',
          shortDescription: 'invalid_email',
          description:
              '''If you attempt to sign in, but the email is invalid, should see invalid error''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: (arrange) async {
            final fakeAuthChangeEffect = FakeAuthChangeEffect();
            when(() => arrange.mocks.authChangeEffectProvider.getEffect())
                .thenAnswer(
              (invocation) => fakeAuthChangeEffect,
            );
          },
        );

        await tester.screenshot(
          description: 'initial state',
          expectations: (expectations) {
            expectations.expect(
              find.byType(SignIn_Page),
              findsOneWidget,
              reason: 'Should be on the SignIn page',
            );
          },
          expectedEvents: [
            'Page: SignIn',
          ],
        );

        await tester.screenshot(
          description: 'enter invalid emaill address',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignInC_EmailTextField),
              'bad email',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'enter password',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignInC_PasswordTextField),
              'password',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'tap submit button',
          actions: (actions) async {
            await actions.userAction.tap(
              find.descendant(
                of: find.byType(SignInC_SignInButton),
                matching: find.byWidgetPredicate((widget) {
                  if (widget is SharedD_Button) {
                    return widget.status == SharedD_Button_Status.enabled;
                  }
                  return false;
                }),
              ),
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(SignIn_Page),
              findsOneWidget,
              reason: 'Should still be on SignIn page',
            );
            expectations.expect(
              find.text('Please enter a valid email address.'),
              findsOneWidget,
              reason: 'Should see email invalid error',
            );
          },
        );
      },
    );

    flowTest(
      'SP3',
      config: createFlowConfig(hasAccessToken: false),
      descriptions: [
        ...baseDescriptions,
        sadPathDescription,
        FTDescription(
          descriptionType: 'AC',
          shortDescription: 'http_error',
          description:
              '''As a user, even if I fill out the form correctly, I can still hit an http error. If this happens, I should be made aware that something went wrong.''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: (arrange) async {
            final fakeAuthChangeEffect = FakeAuthChangeEffect();
            when(() => arrange.mocks.authChangeEffectProvider.getEffect())
                .thenAnswer(
              (invocation) => fakeAuthChangeEffect,
            );
          },
        );

        await tester.screenshot(
          description: 'initial state',
          expectations: (expectations) {
            expectations.expect(
              find.byType(SignIn_Page),
              findsOneWidget,
              reason: 'Should be on the SignIn page',
            );
          },
          expectedEvents: [
            'Page: SignIn',
          ],
        );

        await tester.screenshot(
          description: 'enter email',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignInC_EmailTextField),
              'foo@example.com',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'enter password',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignInC_PasswordTextField),
              'password',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'tap submit button',
          arrangeBeforeActions: (arrange) {
            when(
              () => arrange.mocks.authRepository.signIn(
                email: any(named: 'email'),
                password: any(named: 'password'),
              ),
            ).thenThrow(
              (invocation) async => Exception('BOOM'),
            );
          },
          actions: (actions) async {
            await actions.userAction.tap(find.byType(SignInC_SignInButton));
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(Home_Page),
              findsNothing,
              reason:
                  'Should not be on the Home page because signing in failed',
            );
            expectations.expect(
              find.byType(SignIn_Page),
              findsOneWidget,
              reason: 'Should still be on SignIn page',
            );
            expectations.expect(
              find.text('Could not sign in.'),
              findsOneWidget,
              reason:
                  '''Should see error message letting user know something went wrong.''',
            );
          },
          expectedEvents: [
            SignInEvent_SignIn,
          ],
        );
      },
    );
  });
}
```

Copy the following into `test/flows/unauthenticated/sign_up_test.dart`:

```dart
import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;

import 'package:loading_indicator/loading_indicator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:row_level_security/blocs/auth/event.dart';
// ATTENTION 1/3
import 'package:row_level_security/blocs/count/event.dart';
// ---
import 'package:row_level_security/blocs/sign_up/event.dart';
import 'package:row_level_security/pages/authenticated/home/page.dart';
import 'package:row_level_security/pages/unauthenticated/sign_up/page.dart';
import 'package:row_level_security/pages/unauthenticated/sign_up/widgets/connector/email_text_field.dart';
import 'package:row_level_security/pages/unauthenticated/sign_up/widgets/connector/password_text_field.dart';
import 'package:row_level_security/pages/unauthenticated/sign_up/widgets/connector/sign_up_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../util/fake/auth_change_effect.dart';
import '../../util/fake/supabase_user.dart';
import '../../util/util.dart';
import '../../util/warp/to_sign_up.dart';

void main() {
  final baseDescriptions = [
    FTDescription(
      descriptionType: 'EPIC',
      shortDescription: 'unauthenticated',
      description:
          '''As a user, I need to be able to interact with the appication when I am unauthenticated.''',
    ),
    FTDescription(
      descriptionType: 'STORY',
      shortDescription: 'sign_up',
      description:
          '''As a user, I should be able to sign up for the application, so that I can use it.''',
      atScreenshotsLevel: true,
    ),
  ];

  group('Happy Path', () {
    final happyPathDescription = FTDescription(
      descriptionType: 'PATH',
      shortDescription: 'happy_path',
      description: '''Happy Path: Signing up is successful''',
    );

    flowTest(
      'HP1',
      config: createFlowConfig(
        hasAccessToken: false,
      ),
      descriptions: [
        ...baseDescriptions,
        happyPathDescription,
        FTDescription(
          descriptionType: 'AC',
          shortDescription: 'tapping_inputs',
          description:
              '''There are two ways to fill out the form. This covers manually tapping into each input.''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          warp: warpToSignUp,
          arrangeBeforePumpApp: arrangeBeforeWarpToSignUp,
        );

        await tester.screenshot(
          description: 'initial state',
          expectations: (expectations) {
            expectations.expect(
              find.byType(SignUp_Page),
              findsOneWidget,
              reason: 'Should be on the SignUp page',
            );
          },
        );

        await tester.screenshot(
          description: 'enter email',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignUpC_EmailTextField),
              'foo@example.com',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'enter password',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignUpC_PasswordTextField),
              'Pass123!',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'tap submit button (pump half)',
          arrangeBeforeActions: (arrange) {
            when(
              () => arrange.mocks.authRepository.signUp(
                email: any(named: 'email'),
                password: any(named: 'password'),
              ),
            ).thenAnswer((invocation) async {
              await Future<void>.delayed(const Duration(seconds: 500));
              final fakeAuthChangeEffect = arrange
                  .extras['fakeAuthChangeEffect'] as FakeAuthChangeEffect;
              fakeAuthChangeEffect.streamController?.add(
                supabase.AuthState(
                  supabase.AuthChangeEvent.signedIn,
                  supabase.Session(
                    accessToken: 'fakeAccessToken',
                    tokenType: '',
                    user: FakeSupabaseUser(),
                  ),
                ),
              );
              return;
            });
          },
          actions: (actions) async {
            await actions.userAction.tap(find.byType(SignUpC_SignUpButton));
            await actions.testerAction.pump(const Duration(milliseconds: 250));
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(LoadingIndicator),
              findsOneWidget,
              reason: 'Should see a loading indicator',
            );
            expectations.expect(
              find.byType(Home_Page),
              findsNothing,
              reason: 'Should not be on the Home page yet',
            );
          },
          expectedEvents: [
            SignUpEvent_SignUp,
          ],
        );

        await tester.screenshot(
          description: 'tap submit button (pump rest)',
          arrangeBeforeActions: (arrange) {
            when(() => arrange.mocks.nowEffectProvider.getEffect()).thenAnswer(
              (Invocation invocation) => FakeNowEffect(),
            );
          },
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(Home_Page),
              findsOneWidget,
              reason: 'Should be on the Home page',
            );
          },
          expectedEvents: [
            'INFO: [auth_change_subscription] signedIn',
            AuthEvent_AccessTokenAdded,
            'Page: Home',
            // ATTENTION 2/3
            CountEvent_Initialize,
            // ---
          ],
        );
      },
    );

    flowTest(
      'HP2',
      config: createFlowConfig(
        hasAccessToken: false,
      ),
      descriptions: [
        ...baseDescriptions,
        happyPathDescription,
        FTDescription(
          descriptionType: 'AC',
          shortDescription: 'pressing_enter',
          description:
              '''There are two ways to fill out the form. This covers pressing enter to jump to the next input.''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          warp: warpToSignUp,
          arrangeBeforePumpApp: arrangeBeforeWarpToSignUp,
        );

        await tester.screenshot(
          description: 'initial state',
          expectations: (expectations) {
            expectations.expect(
              find.byType(SignUp_Page),
              findsOneWidget,
              reason: 'Should be on the SignUp page',
            );
          },
        );

        await tester.screenshot(
          description: 'enter email',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignUpC_EmailTextField),
              'foo@example.com',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'press enter',
          actions: (actions) async {
            await actions.userAction.testTextInputReceiveNext();
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'enter password',
          actions: (actions) async {
            await actions.userAction.testTextInputEnterText('Pass123!');
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'press enter (pump half)',
          arrangeBeforeActions: (arrange) {
            when(
              () => arrange.mocks.authRepository.signUp(
                email: any(named: 'email'),
                password: any(named: 'password'),
              ),
            ).thenAnswer((invocation) async {
              await Future<void>.delayed(const Duration(seconds: 500));
              final fakeAuthChangeEffect = arrange
                  .extras['fakeAuthChangeEffect'] as FakeAuthChangeEffect;
              fakeAuthChangeEffect.streamController?.add(
                supabase.AuthState(
                  supabase.AuthChangeEvent.signedIn,
                  supabase.Session(
                    accessToken: 'fakeAccessToken',
                    tokenType: '',
                    user: FakeSupabaseUser(),
                  ),
                ),
              );
              return;
            });
          },
          actions: (actions) async {
            await actions.userAction.testTextInputReceiveDone();
            await actions.testerAction.pump(const Duration(milliseconds: 250));
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(LoadingIndicator),
              findsOneWidget,
              reason: 'Should see a loading indicator',
            );
            expectations.expect(
              find.byType(Home_Page),
              findsNothing,
              reason: 'Should not be on the Home page yet',
            );
          },
          expectedEvents: [
            SignUpEvent_SignUp,
          ],
        );

        await tester.screenshot(
          description: 'press enter (pump rest)',
          arrangeBeforeActions: (arrange) {
            when(() => arrange.mocks.nowEffectProvider.getEffect()).thenAnswer(
              (Invocation invocation) => FakeNowEffect(),
            );
          },
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(Home_Page),
              findsOneWidget,
              reason: 'Should be on the Home page',
            );
          },
          expectedEvents: [
            'INFO: [auth_change_subscription] signedIn',
            AuthEvent_AccessTokenAdded,
            'Page: Home',
            // ATTENTION 3/3
            CountEvent_Initialize,
            // ---
          ],
        );
      },
    );
  });

  group('Sad Path', () {
    final sadPathDescription = FTDescription(
      descriptionType: 'PATH',
      shortDescription: 'sad_path',
      description: '''Sad Path: Signing up is not successful''',
    );

    flowTest(
      'SP1',
      config: createFlowConfig(
        hasAccessToken: false,
      ),
      descriptions: [
        ...baseDescriptions,
        sadPathDescription,
        FTDescription(
          descriptionType: 'AC',
          shortDescription: 'invalid_email',
          description: '''Should see error if invalid email address''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          warp: warpToSignUp,
          arrangeBeforePumpApp: arrangeBeforeWarpToSignUp,
        );

        await tester.screenshot(
          description: 'initial state',
          expectations: (expectations) {
            expectations.expect(
              find.byType(SignUp_Page),
              findsOneWidget,
              reason: 'Should be on the SignUp page',
            );
          },
        );

        await tester.screenshot(
          description: 'enter email',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignUpC_EmailTextField),
              'bad email',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'enter password',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignUpC_PasswordTextField),
              'Pass123!',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'tap submit button',
          actions: (actions) async {
            await actions.userAction.tap(find.byType(SignUpC_SignUpButton));
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(Home_Page),
              findsNothing,
              reason: 'Should not be on the Home page yet',
            );
            expectations.expect(
              find.text('Please enter a valid email address.'),
              findsOneWidget,
              reason: 'Should see invalid email error',
            );
          },
          expectedEvents: [],
        );
      },
    );

    flowTest(
      'SP2',
      config: createFlowConfig(
        hasAccessToken: false,
      ),
      descriptions: [
        ...baseDescriptions,
        sadPathDescription,
        FTDescription(
          descriptionType: 'AC',
          shortDescription: 'invalid_password',
          description: '''Should see error if invalid password''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          warp: warpToSignUp,
          arrangeBeforePumpApp: arrangeBeforeWarpToSignUp,
        );

        await tester.screenshot(
          description: 'initial state',
          expectations: (expectations) {
            expectations.expect(
              find.byType(SignUp_Page),
              findsOneWidget,
              reason: 'Should be on the SignUp page',
            );
          },
        );

        await tester.screenshot(
          description: 'enter email',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignUpC_EmailTextField),
              'john@example.com',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'enter password',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignUpC_PasswordTextField),
              'bad password',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'tap submit button',
          actions: (actions) async {
            await actions.userAction.tap(find.byType(SignUpC_SignUpButton));
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(Home_Page),
              findsNothing,
              reason: 'Should not be on the Home page yet',
            );
            expectations.expect(
              find.text(
                '''Minimum 8 characters, upper and lower case, with at least one special character.''',
              ),
              findsOneWidget,
              reason: 'Should see invalid password error',
            );
          },
          expectedEvents: [],
        );
      },
    );
  });
}
```

Copy the following into `test/flows/unauthenticated/forgot_password_test.dart`:

```dart
import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;

import 'package:loading_indicator/loading_indicator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:row_level_security/blocs/auth/event.dart';
// ATTENTION 1/2
import 'package:row_level_security/blocs/count/event.dart';
// --
import 'package:row_level_security/blocs/forgot_password/event.dart';
import 'package:row_level_security/pages/authenticated/reset_password/page.dart';
import 'package:row_level_security/pages/unauthenticated/forgot_flow/forgot_password/page.dart';
import 'package:row_level_security/pages/unauthenticated/forgot_flow/forgot_password/widgets/connector/email_text_field.dart';
import 'package:row_level_security/pages/unauthenticated/forgot_flow/forgot_password/widgets/connector/reset_password_button.dart';
import 'package:row_level_security/pages/unauthenticated/forgot_flow/forgot_password_confirmation/page.dart';
import 'package:row_level_security/pages/unauthenticated/forgot_flow/forgot_password_confirmation/widgets/connector/resend_email_button.dart';
import 'package:row_level_security/pages/unauthenticated/sign_in/page.dart';

import '../../util/util.dart';
import '../../util/warp/to_forgot_password.dart';
import '../../util/warp/to_forgot_password_confirmation.dart';
import '../../util/warp/to_home.dart';

void main() {
  final baseDescriptions = [
    FTDescription(
      descriptionType: 'EPIC',
      shortDescription: 'unauthenticated',
      description:
          '''As a user, I need to be able to interact with the appication when I am unauthenticated.''',
    ),
    FTDescription(
      descriptionType: 'STORY',
      shortDescription: 'forgot_password',
      description:
          '''As a user, I should be able to recover my account when I have forgotten my password.''',
      atScreenshotsLevel: true,
    ),
  ];

  group('Happy Path', () {
    final happyPathDescription = FTDescription(
      descriptionType: 'PATH',
      shortDescription: 'happy_path',
      description: '''Happy Path: Forgot password flow is successful''',
    );

    flowTest(
      'HP1.A',
      config: createFlowConfig(
        hasAccessToken: false,
      ),
      descriptions: [
        ...baseDescriptions,
        happyPathDescription,
        FTDescription(
          descriptionType: 'PATH',
          shortDescription: 'path_a',
          description:
              '''The forgot password flow is in two parts, this is the first part, part A''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: arrangeBeforeWarpToForgotPassword,
          warp: warpToForgotPassword,
        );

        await tester.screenshot(
          description: 'initial state',
          expectations: (expectations) {
            expectations.expect(
              find.byType(ForgotPassword_Page),
              findsOneWidget,
              reason: 'Should be on the ForgotPassword page',
            );
          },
        );

        await tester.screenshot(
          description: 'enter email address',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(ForgotPasswordC_EmailTextField),
              'john@example.com',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'tap submit button (pump half)',
          arrangeBeforeActions: (arrange) {
            when(
              () => arrange.mocks.authRepository.forgotPassword(
                email: any(named: 'email'),
              ),
            ).thenAnswer((invocation) async {
              await Future<void>.delayed(const Duration(seconds: 500));
              return;
            });
          },
          actions: (actions) async {
            await actions.userAction
                .tap(find.byType(ForgotPasswordC_ResetPasswordButton));
            await actions.testerAction.pump(const Duration(milliseconds: 250));
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(LoadingIndicator),
              findsOneWidget,
              reason: 'Should see a loading indicator',
            );
            expectations.expect(
              find.byType(ForgotPasswordConfirmation_Page),
              findsNothing,
              reason:
                  'Should not be on the ForgotPasswordConfirmation page yet',
            );
          },
          expectedEvents: [
            ForgotPasswordEvent_ForgotPassword,
          ],
        );

        await tester.screenshot(
          description: 'tap submit button (pump rest)',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(ForgotPasswordConfirmation_Page),
              findsOneWidget,
              reason: 'Should be on the ForgotPasswordConfirmation page',
            );
          },
          expectedEvents: [
            'Page: ForgotPasswordConfirmation',
          ],
        );
      },
    );

    flowTest(
      'HP1.B',
      config: createFlowConfig(
        hasAccessToken: false,
        deepLinkOverride: '/deep/resetPassword',
      ),
      descriptions: [
        ...baseDescriptions,
        happyPathDescription,
        FTDescription(
          descriptionType: 'PATH',
          shortDescription: 'path_b',
          description:
              '''The forgot password flow is in two parts, this is the second part, part B''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: (arrange) async {
            await arrangeBeforeWarpToHome(arrange);

            registerFallbackValue(Uri());

            when(
              () => arrange.mocks.authRepository.setSessionFromUri(
                uri: any(named: 'uri'),
              ),
            ).thenAnswer((invocation) async => 'fakeAccessToken');
          },
        );

        await tester.screenshot(
          description: 'initial state',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(ResetPassword_Page),
              findsOneWidget,
              reason: 'Should be on ResetPage page',
            );
          },
          expectedEvents: [
            AuthEvent_SetSessionFromDeepLink,
            'Page: Home',
            'Page: ResetPassword',
            // ATTENTION 2/2
            CountEvent_Initialize,
            // --
          ],
        );
      },
    );

    flowTest(
      'HP2',
      config: createFlowConfig(
        hasAccessToken: false,
      ),
      descriptions: [
        ...baseDescriptions,
        happyPathDescription,
        FTDescription(
          descriptionType: 'AC',
          shortDescription: 'resend_email',
          description:
              '''If you don't receive the password reset email, you should be able to request the email again.''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: arrangeBeforeWarpToForgotPasswordConfirmation,
          warp: warpToForgotPasswordConfirmation,
        );

        await tester.screenshot(
          description: 'initial state',
          expectations: (expectations) {
            expectations.expect(
              find.byType(ForgotPasswordConfirmation_Page),
              findsOneWidget,
              reason: 'Should be on the ForgotPasswordConfirmation page',
            );
          },
        );

        await tester.screenshot(
          description: 'tap resend email',
          actions: (actions) async {
            await actions.userAction.tap(
              find.byType(ForgotPasswordConfirmationC_ResendEmailButton),
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.text('Email resent.'),
              findsOneWidget,
              reason:
                  '''Should see snackbar letting user know that email was resent.''',
            );
          },
          expectedEvents: [
            ForgotPasswordEvent_ResendForgotPassword,
          ],
        );
      },
    );
  });

  group(
    'Sad Path',
    () {
      final sadPathDescription = FTDescription(
        descriptionType: 'PATH',
        shortDescription: 'sad_path',
        description: '''Sad Path: Forgot password flow is not successful''',
      );

      flowTest(
        'SP1.A',
        config: createFlowConfig(
          hasAccessToken: false,
        ),
        descriptions: [
          ...baseDescriptions,
          sadPathDescription,
          FTDescription(
            descriptionType: 'AC',
            shortDescription: 'path_a_email_invalid',
            description:
                '''If you attempt to reset password, but the email is invalid, should see invalid error''',
          ),
        ],
        test: (tester) async {
          await tester.setUp(
            arrangeBeforePumpApp: arrangeBeforeWarpToForgotPassword,
            warp: warpToForgotPassword,
          );

          await tester.screenshot(
            description: 'initial state',
            expectations: (expectations) {
              expectations.expect(
                find.byType(ForgotPassword_Page),
                findsOneWidget,
                reason: 'Should be on the ForgotPassword page',
              );
            },
          );

          await tester.screenshot(
            description: 'enter email address',
            actions: (actions) async {
              await actions.userAction.enterText(
                find.byType(ForgotPasswordC_EmailTextField),
                'bad email',
              );
              await actions.testerAction.pumpAndSettle();
            },
          );

          await tester.screenshot(
            description: 'tap submit button',
            actions: (actions) async {
              await actions.userAction
                  .tap(find.byType(ForgotPasswordC_ResetPasswordButton));
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.text('Please enter a valid email address.'),
                findsOneWidget,
                reason: 'Should see email invalid error',
              );
            },
            expectedEvents: [],
          );
        },
      );

      flowTest(
        'SP1.B',
        config: createFlowConfig(
          hasAccessToken: false,
          deepLinkOverride: '/deep/resetPassword',
        ),
        descriptions: [
          ...baseDescriptions,
          sadPathDescription,
          FTDescription(
            descriptionType: 'PATH',
            shortDescription: 'path_b_error',
            description:
                '''The forgot password flow is in two parts, this is the second part, part B, and the deep link can fail''',
          ),
        ],
        test: (tester) async {
          await tester.setUp(
            arrangeBeforePumpApp: (arrange) async {
              await arrangeBeforeWarpToHome(arrange);

              registerFallbackValue(Uri());

              when(
                () => arrange.mocks.authRepository.setSessionFromUri(
                  uri: any(named: 'uri'),
                ),
              ).thenThrow(Exception('BOOM'));
            },
          );

          await tester.screenshot(
            description: 'initial state',
            actions: (actions) async {
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.byType(SignIn_Page),
                findsOneWidget,
                reason: 'Should be on SignIn page',
              );
            },
            expectedEvents: [
              AuthEvent_SetSessionFromDeepLink,
              'Page: SignIn',
            ],
          );
        },
      );

      flowTest(
        'SP2',
        config: createFlowConfig(
          hasAccessToken: false,
        ),
        descriptions: [
          ...baseDescriptions,
          sadPathDescription,
          FTDescription(
            descriptionType: 'AC',
            shortDescription: 'resend_email_error',
            description:
                '''If you don't receive the password reset email, you should be able to request the email again, but the request can fail.''',
          ),
        ],
        test: (tester) async {
          await tester.setUp(
            arrangeBeforePumpApp: arrangeBeforeWarpToForgotPasswordConfirmation,
            warp: warpToForgotPasswordConfirmation,
          );

          await tester.screenshot(
            description: 'initial state',
            expectations: (expectations) {
              expectations.expect(
                find.byType(ForgotPasswordConfirmation_Page),
                findsOneWidget,
                reason: 'Should be on the ForgotPasswordConfirmation page',
              );
            },
          );

          await tester.screenshot(
            description: 'tap resend email',
            arrangeBeforeActions: (arrange) {
              when(
                () => arrange.mocks.authRepository.forgotPassword(
                  email: any(named: 'email'),
                ),
              ).thenThrow(Exception('BOOM'));
            },
            actions: (actions) async {
              await actions.userAction.tap(
                find.byType(ForgotPasswordConfirmationC_ResendEmailButton),
              );
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.text('Could not resend email.'),
                findsOneWidget,
                reason:
                    '''Should see snackbar letting user know that email was not able to be resent.''',
              );
            },
            expectedEvents: [
              ForgotPasswordEvent_ResendForgotPassword,
            ],
          );
        },
      );
    },
  );
}
```

Now that those tests are updated, we can start working on our new test file. We
want to start at the `Home_Page`, so let's update the warp to home at
`test/util/warp/to_home.dart`.

```dart
import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../fake/auth_change_effect.dart';
import '../util.dart';

Future<void> arrangeBeforeWarpToHome(
  FTArrange<MocksContainer> arrange,
) async {
  final fakeAuthChangeEffect = FakeAuthChangeEffect();
  when(() => arrange.mocks.authChangeEffectProvider.getEffect()).thenAnswer(
    (invocation) => fakeAuthChangeEffect,
  );
  arrange.extras['fakeAuthChangeEffect'] = fakeAuthChangeEffect;

  // ATTENTION 1
  when(() => arrange.mocks.countRepository.getCount())
      .thenAnswer((invocation) async => 0);
  // ---
}

// Note: Set `hasAccessToken` to true
```

Next, let's create a new test file:

```sh
cd app/test/flows

mkdir authenticated
touch authenticated/count_test.dart
```

Copy the following into `test/flows/authenticated/count_test.dart`:

```dart
import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;

import 'package:mocktail/mocktail.dart';
import 'package:row_level_security/blocs/count/event.dart';
import 'package:row_level_security/pages/authenticated/home/page.dart';
import 'package:row_level_security/pages/authenticated/home/widgets/connector/decrement_button.dart';
import 'package:row_level_security/pages/authenticated/home/widgets/connector/increment_button.dart';

import '../../util/util.dart';
import '../../util/warp/to_home.dart';

void main() {
  final baseDescriptions = [
    FTDescription(
      descriptionType: 'EPIC',
      shortDescription: 'authenticated',
      description:
          '''As a user, I need to be able to interact with the appication when I am authenticated.''',
    ),
    FTDescription(
      descriptionType: 'STORY',
      shortDescription: 'counter',
      description:
          '''As a user, I should be able to read and change the count in the counter.''',
      atScreenshotsLevel: true,
    ),
  ];

  flowTest(
    'AC1',
    config: createFlowConfig(
      hasAccessToken: true,
    ),
    descriptions: [
      ...baseDescriptions,
      FTDescription(
        descriptionType: 'AC',
        shortDescription: 'update_count_success',
        description: '''Should be able update the count successfully.''',
      ),
    ],
    test: (tester) async {
      await tester.setUp(
        arrangeBeforePumpApp: arrangeBeforeWarpToHome,
      );

      await tester.screenshot(
        description: 'initial state',
        expectations: (expectations) {
          expectations.expect(
            find.byType(Home_Page),
            findsOneWidget,
            reason: 'Should be on the Home page',
          );
          expectations.expect(
            find.text('0'),
            findsOneWidget,
            reason: 'The initial count should be 0',
          );
        },
        expectedEvents: [
          'Page: Home',
          CountEvent_Initialize,
        ],
      );

      await tester.screenshot(
        description: 'increment count',
        arrangeBeforeActions: (arrange) {
          when(
            () => arrange.mocks.countRepository
                .updateCount(newCount: any(named: 'newCount')),
          ).thenAnswer(
            (invocation) async =>
                invocation.namedArguments[const Symbol('newCount')] as int,
          );
        },
        actions: (actions) async {
          await actions.userAction.tap(find.byType(HomeC_IncrementButton));
          await actions.testerAction.pumpAndSettle();
        },
        expectations: (expectations) {
          expectations.expect(
            find.text('1'),
            findsOneWidget,
            reason: 'The updated count should be 1',
          );
        },
        expectedEvents: [
          CountEvent_Increment,
        ],
      );

      await tester.screenshot(
        description: 'decrement count',
        arrangeBeforeActions: (arrange) {
          when(
            () => arrange.mocks.countRepository
                .updateCount(newCount: any(named: 'newCount')),
          ).thenAnswer(
            (invocation) async =>
                invocation.namedArguments[const Symbol('newCount')] as int,
          );
        },
        actions: (actions) async {
          await actions.userAction.tap(find.byType(HomeC_DecrementButton));
          await actions.testerAction.pumpAndSettle();
          await actions.userAction.tap(find.byType(HomeC_DecrementButton));
          await actions.testerAction.pumpAndSettle();
        },
        expectations: (expectations) {
          expectations.expect(
            find.text('-1'),
            findsOneWidget,
            reason: 'The updated count should be 11',
          );
        },
        expectedEvents: [
          CountEvent_Decrement,
          CountEvent_Decrement,
        ],
      );
    },
  );

  flowTest(
    'AC2',
    config: createFlowConfig(
      hasAccessToken: true,
    ),
    descriptions: [
      ...baseDescriptions,
      FTDescription(
        descriptionType: 'AC',
        shortDescription: 'update_count_failed',
        description:
            '''If updating the count fails, don't change the count. Note: in the future, we may want to update this requirement to give feedback to the user that the update failed.''',
      ),
    ],
    test: (tester) async {
      await tester.setUp(
        arrangeBeforePumpApp: arrangeBeforeWarpToHome,
      );

      await tester.screenshot(
        description: 'initial state',
        expectations: (expectations) {
          expectations.expect(
            find.byType(Home_Page),
            findsOneWidget,
            reason: 'Should be on the Home page',
          );
          expectations.expect(
            find.text('0'),
            findsOneWidget,
            reason: 'The initial count should be 0',
          );
        },
        expectedEvents: [
          'Page: Home',
          CountEvent_Initialize,
        ],
      );

      await tester.screenshot(
        description: 'increment count',
        arrangeBeforeActions: (arrange) {
          when(
            () => arrange.mocks.countRepository
                .updateCount(newCount: any(named: 'newCount')),
          ).thenThrow(Exception('BOOM'));
        },
        actions: (actions) async {
          await actions.userAction.tap(find.byType(HomeC_IncrementButton));
          await actions.testerAction.pumpAndSettle();
        },
        expectations: (expectations) {
          expectations.expect(
            find.text('0'),
            findsOneWidget,
            reason: 'Updating the count failed, so the count should stay 0',
          );
        },
        expectedEvents: [
          CountEvent_Increment,
        ],
      );

      await tester.screenshot(
        description: 'decrement count',
        arrangeBeforeActions: (arrange) {
          when(
            () => arrange.mocks.countRepository
                .updateCount(newCount: any(named: 'newCount')),
          ).thenThrow(Exception('BOOM'));
        },
        actions: (actions) async {
          await actions.userAction.tap(find.byType(HomeC_DecrementButton));
          await actions.testerAction.pumpAndSettle();
        },
        expectations: (expectations) {
          expectations.expect(
            find.text('0'),
            findsOneWidget,
            reason: 'Updating the count failed, so the count should stay 0',
          );
        },
        expectedEvents: [
          CountEvent_Decrement,
        ],
      );
    },
  );
}
```

## Step 10: Add database tests

For our database tests, we want to make use of
[supabase_test_helpers](https://database.dev/basejump/supabase_test_helpers). To
be able to install that, we first need to install
[dbdev](https://database.dev/).

We need to make a new migration file:

```sh
supabase migration new install_dbdev_and_test_helpers
```

And copy the following into it:

```sql
/*---------------------
---- install dbdev ----
----------------------
Requires:
  - pg_tle: https://github.com/aws/pg_tle
  - pgsql-http: https://github.com/pramsey/pgsql-http
*/
create extension if not exists http with schema extensions;
create extension if not exists pg_tle;
select pgtle.uninstall_extension_if_exists('supabase-dbdev');
drop extension if exists "supabase-dbdev";
select
    pgtle.install_extension(
        'supabase-dbdev',
        resp.contents ->> 'version',
        'PostgreSQL package manager',
        resp.contents ->> 'sql'
    )
from http(
    (
        'GET',
        'https://api.database.dev/rest/v1/'
        || 'package_versions?select=sql,version'
        || '&package_name=eq.supabase-dbdev'
        || '&order=version.desc'
        || '&limit=1',
        array[
            (
                'apiKey',
                'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJp'
                || 'c3MiOiJzdXBhYmFzZSIsInJlZiI6InhtdXB0cHBsZnZpaWZyY'
                || 'ndtbXR2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODAxMDczNzI'
                || 'sImV4cCI6MTk5NTY4MzM3Mn0.z2CN0mvO2No8wSi46Gw59DFGCTJ'
                || 'rzM0AQKsu_5k134s'
            )::http_header
        ],
        null,
        null
    )
) x,
lateral (
    select
        ((row_to_json(x) -> 'content') #>> '{}')::json -> 0
) resp(contents);
create extension "supabase-dbdev";
select dbdev.install('supabase-dbdev');
drop extension if exists "supabase-dbdev";
create extension "supabase-dbdev";

-- Install supabase_test_helpers
select dbdev.install('basejump-supabase_test_helpers');
```

Then let's run the following to apply the change:

```sh
supabase migration up
```

Now we can write our database test. Let's start by creating a test file.

```sh
supabase test new insert_count_on_signup
```

Then copy the following into `supabase/tests/insert_count_on_signup_test.sql`:

```sql
BEGIN;
CREATE EXTENSION "basejump-supabase_test_helpers" VERSION '0.0.1';

SELECT plan(8);


-- Check public.counts table
SELECT has_table('public', 'counts', 'Should have public.counts table');
SELECT has_column('public', 'counts', 'user_id', 'Should have public.counts.user_id column');
SELECT has_column('public', 'counts', 'count', 'Should have public.counts.count column');
SELECT col_is_fk('public', 'counts', 'user_id', 'public.counts.user_id should be a foreign key');

-- Check trigger_on_signup_insert_count
SELECT has_function('public', 'on_signup_insert_count', 'Should have on_signup_insert_count function');
SELECT has_trigger('auth', 'users', 'trigger_on_signup_insert_count', 'Should have trigger_on_signup_insert_count trigger');


PREPARE john_doe_rows AS SELECT count(*) FROM public.counts WHERE user_id = tests.get_supabase_uid('john_doe');

-- John should not exist in the public.counts table yet
SELECT results_eq(
  'john_doe_rows',
  $$SELECT 0::bigint$$,
  'Should be zero rows for john doe in public.counts table'
);


-- Create user
SELECT tests.create_supabase_user('john_doe');


-- Check if trigger_on_signup_instert_count ran successfully

SELECT results_eq(
  'john_doe_rows',
  $$SELECT 1::bigint$$,
  'Should be one row for john doe in public.counts table'
);


SELECT * FROM finish();
ROLLBACK;
```

You can run your database tests by running:

```sh
supabse db test
```

Finally, we can write our last database test. This will check the row-level
security! Create a new test file:

```sh
supabase test new rls_count_table
```

Then copy the following into `supabase/tests/rls_count_table.sql`:

```sql
BEGIN;
CREATE EXTENSION "basejump-supabase_test_helpers" VERSION '0.0.1';

SELECT plan(12);

-- Create two users
SELECT tests.create_supabase_user('john');
SELECT tests.create_supabase_user('jane');



-- Authenticate as John
SELECT tests.authenticate_as('john');

-- John should be able to read his row
SELECT results_eq(
  $$SELECT count(*) FROM public.counts WHERE user_id = tests.get_supabase_uid('john');$$,
  $$SELECT 1::bigint$$,
  'John should be able to read his row in public.counts table'
);
-- But not Jane's row
SELECT results_eq(
  $$SELECT count(*) FROM public.counts WHERE user_id = tests.get_supabase_uid('jane');$$,
  $$SELECT 0::bigint$$,
  'John should NOT be able to read the row belonging to Jane'
);

-- John should be able to update his row
SELECT lives_ok(
  $$UPDATE public.counts SET count = 1 WHERE user_id = tests.get_supabase_uid('john');$$,
  'John increments his own count'
);
SELECT results_eq(
  $$SELECT c.count FROM public.counts c WHERE user_id = tests.get_supabase_uid('john');$$,
  $$SELECT 1::bigint$$,
  'When John reads his count, it should have incremented'
);
-- But not Jane's row
SELECT lives_ok(
  $$UPDATE public.counts SET count = 1 WHERE user_id = tests.get_supabase_uid('jane');$$,
  'John attempts increments the count belonging to Jane'
);
SELECT is_empty(
  $$SELECT c.count FROM public.counts AS c WHERE user_id = tests.get_supabase_uid('jane');$$,
  'When John reads the count belonging to Jane, he should get back NULL'
);


-- Authenticate as Jane
SELECT tests.authenticate_as('jane');

-- Jane should be able to read her row
SELECT results_eq(
  $$SELECT count(*) FROM public.counts WHERE user_id = tests.get_supabase_uid('jane');$$,
  $$SELECT 1::bigint$$,
  'Jane should be able to read his row in public.counts table'
);
-- But not John's row
SELECT results_eq(
  $$SELECT count(*) FROM public.counts WHERE user_id = tests.get_supabase_uid('john');$$,
  $$SELECT 0::bigint$$,
  'Jane should NOT be able to read the row belonging to John'
);

-- Jane should be able to update her row
SELECT lives_ok(
  $$UPDATE public.counts SET count = 1 WHERE user_id = tests.get_supabase_uid('jane');$$,
  'Jane increments her own count'
);
SELECT results_eq(
  $$SELECT c.count FROM public.counts c WHERE user_id = tests.get_supabase_uid('jane');$$,
  $$SELECT 1::bigint$$,
  'When Jane reads her count, it should have incremented'
);
-- But not Jane's row
SELECT lives_ok(
  $$UPDATE public.counts SET count = 1 WHERE user_id = tests.get_supabase_uid('jane');$$,
  'Jane attempts increments the count belonging to John'
);
SELECT is_empty(
  $$SELECT c.count FROM public.counts AS c WHERE user_id = tests.get_supabase_uid('john');$$,
  'When Jane reads the count belonging to John, she should get back NULL'
);

SELECT * FROM finish();
ROLLBACK;
```
