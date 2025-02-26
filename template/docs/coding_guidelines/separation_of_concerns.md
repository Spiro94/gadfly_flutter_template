# Separation of Concerns

We use [flutter_bloc](https://pub.dev/packages/flutter_bloc) for state management, and it works best when we adhere to a strict separation of concerns.

At a high-level, we split our code into two layers:

- outside (i.e. outside of the widget tree)
- inside (i.e. inside of the widget tree)

The primary driver for this separation is to unlock testing. If we have a need to mock something in our Flow Tests, then should be created "outside" of the widget tree in [appRunner] and passed into [appBuilder] as an argument.

## Boundary between Inside and Outside Layers

We have a strict boundary between the **inside** and **outside** layers.

Everything that is outside of the widget tree is instantiated in the `appRunner` function. For example, client providers, effect providers, and repositories are all instantiated as singletons.

Anything that is **outside** must be passed in to the **inside** layer through the **"front door"** of our application: the `appBuilder` function. Every single Flow Test starts with the `appBuilder` function. This means that we can mock the outside singletons and control their output in our tests.

## Summary

![outside vs inside](images/outside_vs_inside.png?raw=true)

|                                                         | Client Provider | Effect Provider | Repository | Cubit | Bloc | Effect |
|---------------------------------------------------------|-----------------|-----------------|------------|-------|------|--------|
| is a singleton                                          | x               | x               | x          |       |      |        |
| instantiated "outside" in appRunner                     | x               | x               | x          |       |      |        |
| instantiated "inside" widget tree                       |                 |                 |            | x     | x    | x      |
| can be an argument to an Effect Provider                | x               |                 |            |       |      |        |
| can be an argument to a Repository                      | x               | x               |            |       |      |        |
| can be an argument to a Cubit                           |                 | x               | x          |       |      |        |
| can be an argument to a Bloc                            |                 | x               | x          | x     |      |        |
| can be an argument to appBuilder                        |                 | x               | x          |       |      |        |
| can hold entity state                                   |                 |                 |            | x     |      |        |
| can hold application state                              |                 |                 |            |       | x    |        |
| can perform a side-effect                               | x               |                 | x          |       |      | x      |
| methods can be used directly in widget tree             |                 |                 |            | x     |      | x      |
| can be mocked in Flow Tests                             |                 | x               | x          |       |      |        |

## Client Providers

A Client Provider is a singleton that is instantiated in the `appRunner` function, and is **not** passed into the `appBuilder` function.

A Client Provider's responsibility is to provide a Client.

A Client can perform a side-effect, such as interacting with the outside world (like a database).

A Client can be passed into Effect Providers and Repositories.

For the most part, we do not need to create Client Providers. The only reason we would is if we need the same client in multiple Effect Providers and/or Repositories.

|                                                         | Client Provider |
|---------------------------------------------------------|-----------------|
| is a singleton                                          | x               |
| instantiated "outside" in appRunner                     | x               |
| instantiated "inside" widget tree                       |                 |
| can be an argument to an Effect Provider                |                 |
| can be an argument to a Repository                      | x               |
| can be an argument to a Cubit                           |                 |
| can be an argument to a Bloc                            |                 |
| can be an argument to appBuilder                        |                 |
| can hold entity state                                   |                 |
| can hold application state                              |                 |
| can perform a side-effect                               | x               |
| methods can be used directly in widget tree             |                 |
| can be mocked in Flow Tests                             |                 |

## Effect Providers

An Effect Provider is a singleton that is instantiated in the `appRunner` function, and is **not** passed into the `appBuilder` function.

An Effect Provider's responsibility is to provide an Effect.

An Effect can perform a side-effect, but it is different than a Client or a Repository because:

- it is not a singleton
- is instantiated in the widget tree
- its methods can be used directly in the widget tree

An Effect Provider can be passed into Repositories, Cubits, and Blocs. An Effect is generally not passed in to anything.

An Effect Provider should be mocked in Flow Tests.

|                                                         | Effect Provider | Effect |
|---------------------------------------------------------|-----------------|--------|
| is a singleton                                          | x               |        |
| instantiated "outside" in appRunner                     | x               |        |
| instantiated "inside" widget tree                       |                 | x      |
| can be an argument to an Effect Provider                |                 |        |
| can be an argument to a Repository                      | x               |        |
| can be an argument to a Cubit                           | x               |        |
| can be an argument to a Bloc                            | x               |        |
| can be an argument to appBuilder                        | x               |        |
| can hold entity state                                   |                 |        |
| can hold application state                              |                 |        |
| can perform a side-effect                               |                 | x      |
| methods can be used directly in widget tree             |                 | x      |
| can be mocked in Flow Tests                             | x               |        |

## Repositories

An Repository is a singleton that is instantiated in the `appRunner` function, and **is** passed into the `appBuilder` function.

An Repository's responsibility is to provide methods that perform some kind of side-effect to Blocs and Cubits.

A Repository is different than an Effect because:

- it is a singleton
- is not instantiated in the widget tree
- its methods cannot be used directly in the widget tree

A Repository is different than a Cubit because:

- it is a singleton
- is not instantiated in the widget tree
- it cannot store state

A Repository can be passed into Cubits, and Blocs.

A Repository should be mocked in Flow Tests.

|                                                         | Repositories    |
|---------------------------------------------------------|-----------------|
| is a singleton                                          | x               |
| instantiated "outside" in appRunner                     | x               |
| instantiated "inside" widget tree                       |                 |
| can be an argument to an Effect Provider                |                 |
| can be an argument to a Repository                      |                 |
| can be an argument to a Cubit                           | x               |
| can be an argument to a Bloc                            | x               |
| can be an argument to appBuilder                        | x               |
| can hold entity state                                   |                 |
| can hold application state                              |                 |
| can perform a side-effect                               | x               |
| methods can be used directly in widget tree             |                 |
| can be mocked in Flow Tests                             | x               |

## Cubits and Blocs

Cubits and Blocs are instantiated in the widget tree.

Cubits and Blocs:

- respond to interactions from users
- process those interactions and produce new states
- the widget tree can listen to these new states and update themselves accordingly

The primary difference between a Cubit and a Bloc is that:

- Cubits expose methods that can be called directly in the widget tree
- Blocs are driven by events that can be dispatched in the widget tree

We use Blocs for application state. For example, keeping track of whether or not a page has finished loading.

We use Cubits for entity state. For example, if we have a profile object, we can store that in a Cubit. We do this because it is likely that multiple pages or flows of pages need this same information. So rather than refetching that information and storing it separately in different blocs, we can have a single-source of truth in a Cubit. We can pass the Cubit into different Blocs, the Bloc can call methods from the Cubit, and the Cubit can update its state.

From the perspective of a Bloc, a Cubit is different than a Repository because:

- it can carry state
- all of its methods are void callbacks

Cubits and Repositories should **not** be mocked in Flow Tests.

|                                                         | Cubits          | Blocs |
|---------------------------------------------------------|-----------------|-------|
| is a singleton                                          |                 |       |
| instantiated "outside" in appRunner                     |                 |       |
| instantiated "inside" widget tree                       | x               | x     |
| can be an argument to an Effect Provider                |                 |       |
| can be an argument to a Repository                      |                 |       |
| can be an argument to a Cubit                           |                 |       |
| can be an argument to a Bloc                            | x               |       |
| can be an argument to appBuilder                        |                 |       |
| can hold entity state                                   | x               |       |
| can hold application state                              |                 | x     |
| can perform a side-effect                               |                 |       |
| methods can be used directly in widget tree             | x               |       |
| can be mocked in Flow Tests                             |                 |       |
