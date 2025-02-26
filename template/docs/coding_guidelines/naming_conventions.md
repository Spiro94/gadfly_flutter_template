# Naming Conventions

## Client Providers

A Client Provider will have the name of:

```dart
ClientProviderName_ClientProvider
```

For example:

```dart
Sentry_ClientProvider
Supabase_ClientProvider
```

## Effect Providers

An Effect Provider will have the name of:

```dart
EffectProviderName_EffectProvider
```

For example:

```dart
Mixpanel_EffectProvider
Now_EffectProvider
```

## Effects

An Effect will have the name of:

```dart
EffectName_Effect
```

For example:

```dart
Mixpanel_Effect
Now_Effect
```

## Repositories

A Repository will have the name of:

```dart
RepositoryName_Repository
```

For example:

```dart
Auth_Repository
```

## Blocs

Blocs are made up of 3 files:

- `bloc.dart`
- `events.dart`
- `state.dart`

### Bloc Name

The Bloc itself will have the name of:

```dart
BlocName_Bloc
```

For example:

```dart
Auth_Bloc
ResetPassword_Bloc
SignUp_Bloc
```

### Event Name

An Event will have the name of:

```dart
BlocName_Event_ActionName
```

For example:

```dart
Auth_Event_GetAccessTokenFromUri
SignIn_Event_SignIn
SignUp_Event_ResendEmailVerificationlink
```

### State Name

The State will have the name of:

```dart
BlocName_State
```

For example:

```dart
Auth_State
ResetPassword_State
SignUp_State
```

All States will have an accompanying Status that will have the name of:

```dart
BlocName_Status
```

For example:

```dart
Auth_Status
ResetPassword_Status
SignUp_Status
```

## Widgets

To talk about widgets, we need to talk about the `inside/routes` directory. Widgets can belong to one of three locations:

- `inside/routes/flow_name/route_name/widgets`: These are route-level widgets that can be used by that specific route.
- `inside/routes/flow_name/widgets`: These are flow-level widgets that can be used by any route within that flow of routes.
- `inside/routes/widgets/`: These are top-level widgets that can be used by any route.

The naming convention of a widget has up to three segments:

```dart
WidgetLocation_WidgetType_WidgetDescription
```

**WidgetLocation**: This can be:

- The route name. For example: `Home` or `SignUp`
- The flow name for a flow of routes. For example: `ForgotPasswordFlow`
- The top-level name for a widget, with is `Routes`

**WidgetType**: This should tell us what the type of the widget is. Some examples include:

- `Text`
- `Button`
- `Input`
- `Listener`

**WidgetDescription**: This is optional, but recommended. This is used to understand the intent of the widget and to disambiguate from other widgets of the same type at the same location. For example:

- `Submit`
- `Email`
- `Title`
- `StatusChange`

All together, some of these widget names could be:

```dart
Routes_Listener_AuthStatusChange
OnboardingFlow_Text_Title
SignIn_Input_Email
```
