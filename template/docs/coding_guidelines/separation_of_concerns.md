# Separation of Concerns

We use [flutter_bloc](https://pub.dev/packages/flutter_bloc) for state management, and it works best when we adhere to a strict separation of concerns. In our applications, we will have the following layers:

- client providers
- repositories
- effect providers
- effects
- blocs
