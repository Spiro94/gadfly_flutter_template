# Naming Conventions

## Blocs

Blocs are made up of 3 files:

- `bloc.dart`
- `events.dart`
- `state.dart`

### Bloc Name

The Bloc itself will have the name of:

```dart
BlocNameBloc
```

For example:

```dart
AuthBloc
ResetPasswordBloc
SignUpBloc
```

### Event Name

An Event will have the name of:

```dart
BlocNameEvent_ActionName
```

For example:

```dart
AuthEvent_GetAccessTokenFromUri
SignInEvent_SignIn
SignUpEvent_ResendEmailVerificationlink
```

### State Name

The State will have the name of:

```dart
BlocNameState
```

For example:

```dart
AuthState
ResetPasswordState
SignUpState
```

All States will have an accompanying Status that will have the name of:

```dart
BlocNameStatus
```

For example:

```dart
AuthStatus
ResetPasswordStatus
SignUpStatus
```

## Widgets

To talk about widgets, we need to talk about the `internal/routes` directory. Widgets can belong to one of three locations:

- `internal/routes/flow_name/route_name/widgets`: These are route-level widgets that can be used by that specific route.
- `internal/routes/flow_name/widgets`: These are flow-level widgets that can be used by any route within that flow of routes.
- `internal/routes/widgets/`: These are top-level widgets that can be used by any route.

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
