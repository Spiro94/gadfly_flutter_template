import 'package:flow_test/flow_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;
import 'package:gadfly_flutter_template/blocs/recordings/event.dart';
import 'package:gadfly_flutter_template/pages/authenticated/home/widgets/connector/play_audio_buttons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../util/flow_config.dart';
import '../../util/warp/to_home.dart';

void main() {
  final baseDescriptions = [
    FTDescription(
      descriptionType: 'EPIC',
      directoryName: 'audio',
      description: '''As a user, I need to be able to record and play audio.''',
    ),
    FTDescription(
      descriptionType: 'STORY',
      directoryName: 'play',
      description: '''As a user, I should be able to play audio.''',
      atScreenshotsLevel: true,
    ),
  ];

  group('getMyRecordingsStream', () {
    flowTest(
      'error',
      config: createFlowConfig(
        hasAccessToken: true,
      ),
      descriptions: [
        ...baseDescriptions,
        FTDescription(
          descriptionType: 'AC',
          directoryName: 'get_my_recordings',
          description: '''Fetch recordings from database''',
        ),
        FTDescription(
          descriptionType: 'STATUS',
          directoryName: 'error',
          description: '''Is error''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: (arrange) async {
            await arrangeBeforeWarpToHome(arrange);

            // -- Overwrite
            when(
              () => arrange.mocks.audioRepository
                  .getMyRecordingsStream(userId: any(named: 'userId')),
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
              find.text('Uh oh, your recordings were not fetched.'),
              findsOneWidget,
              reason: 'Should see error snackbar',
            );
          },
          expectedEvents: [
            'INFO: [router] deeplink: /',
            'Page: Home',
            RecordingsEvent_GetMyRecordings,
            'WARNING: [recordings_bloc] recordings were not fetched',
          ],
        );
      },
    );
  });

  group('play', () {
    flowTest(
      'success',
      config: createFlowConfig(
        hasAccessToken: true,
      ),
      descriptions: [
        ...baseDescriptions,
        FTDescription(
          descriptionType: 'AC',
          directoryName: 'success',
          description: '''Is successful''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: (arrange) async {
            await arrangeBeforeWarpToHome(arrange);

            // -- Overwrite
            when(
              () => arrange.mocks.audioRepository
                  .getMyRecordingsStream(userId: any(named: 'userId')),
            ).thenAnswer((invocation) async {
              return Stream.fromIterable([
                [
                  {
                    'path_tokens': ['userId1', 'recording1'],
                  },
                  {
                    'path_tokens': ['userId2', 'recording2'],
                  },
                ],
              ]);
            });

            when(
              () => arrange.mocks.audioRepository.getSignedRecordingUrls(
                recordingNames: any(named: 'recordingNames'),
              ),
            ).thenAnswer((invocation) async {
              return [
                const SignedUrl(
                  path: 'userId1/recording1',
                  signedUrl: 'fakeSignedUrl1',
                ),
                const SignedUrl(
                  path: 'userId2/recording2',
                  signedUrl: 'fakeSignedUrl2',
                ),
              ];
            });

            when(
              () => arrange.mocks.uuidEffect
                  .generateUuidV4(debugLabel: any(named: 'debugLabel')),
            ).thenAnswer((invocation) {
              final uuid = invocation.namedArguments[const Symbol('debugLabel')]
                  as String;
              return uuid;
            });
          },
        );

        await tester.screenshot(
          description: 'initial state',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.text('recording1'),
              findsOneWidget,
              reason: 'Should see recording 1',
            );
            expectations.expect(
              find.text('recording2'),
              findsOneWidget,
              reason: 'Should see recording 2',
            );
          },
          expectedEvents: [
            'INFO: [router] deeplink: /',
            'Page: Home',
            RecordingsEvent_GetMyRecordings,
            RecordingsEvent_SetMyRecordings,
          ],
        );

        await tester.screenshot(
          description: 'play recording 1 (pump half)',
          arrangeBeforeActions: (arrange) {
            final playAudioEffect = arrange.mocks.playAudioEffects
                .firstWhere((e) => e.debugLabel == 'recording1');

            when(() => playAudioEffect.setUrl(url: any(named: 'url')))
                .thenAnswer((invocation) async {});

            when(playAudioEffect.play).thenAnswer((invocation) async {
              playAudioEffect.streamController
                  ?.add(PlayerState(false, ProcessingState.loading));
            });
          },
          actions: (actions) async {
            await actions.userAction.tap(
              find.descendant(
                of: find.byType(HomeC_PlayAudioButtons),
                matching: find.byKey(const Key('recording1')),
              ),
            );
            await actions.testerAction.pump(const Duration(milliseconds: 300));
          },
          expectations: (expectations) {
            expectations.expect(
              find.byKey(const Key('loading')),
              findsOneWidget,
              reason: 'Should see loading icon',
            );
          },
          expectedEvents: [],
        );

        await tester.screenshot(
          description: 'play recording 1 (pump rest)',
          arrangeBeforeActions: (arrange) {
            final playAudioEffect = arrange.mocks.playAudioEffects
                .firstWhere((e) => e.debugLabel == 'recording1');

            playAudioEffect.streamController
                ?.add(PlayerState(true, ProcessingState.ready));
          },
          actions: (actions) async {
            await actions.testerAction.pump(const Duration(milliseconds: 300));
          },
          expectations: (expectations) {
            expectations.expect(
              find.ancestor(
                of: find.text('recording1'),
                matching: find.byKey(const Key('pause')),
              ),
              findsOneWidget,
              reason: 'Should see pause icon because recording is playing',
            );
          },
          expectedEvents: [],
        );

        await tester.screenshot(
          description: 'pause',
          arrangeBeforeActions: (arrange) {
            final playAudioEffect = arrange.mocks.playAudioEffects
                .firstWhere((e) => e.debugLabel == 'recording1');

            when(playAudioEffect.pause).thenAnswer((invocation) async {
              playAudioEffect.streamController
                  ?.add(PlayerState(false, ProcessingState.ready));
            });
          },
          actions: (actions) async {
            await actions.userAction.tap(
              find.descendant(
                of: find.byType(HomeC_PlayAudioButtons),
                matching: find.byKey(const Key('recording1')),
              ),
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.ancestor(
                of: find.text('recording1'),
                matching: find.byKey(const Key('resume')),
              ),
              findsOneWidget,
              reason: 'Should see resume icon, because recording is paused',
            );
          },
          expectedEvents: [],
        );

        await tester.screenshot(
          description: 'resume',
          arrangeBeforeActions: (arrange) {
            final playAudioEffect = arrange.mocks.playAudioEffects
                .firstWhere((e) => e.debugLabel == 'recording1');

            when(playAudioEffect.play).thenAnswer((invocation) async {
              playAudioEffect.streamController
                  ?.add(PlayerState(true, ProcessingState.completed));
            });
          },
          actions: (actions) async {
            await actions.userAction.tap(
              find.descendant(
                of: find.byType(HomeC_PlayAudioButtons),
                matching: find.byKey(const Key('recording1')),
              ),
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.ancestor(
                of: find.text('recording1'),
                matching: find.byKey(const Key('replay')),
              ),
              findsOneWidget,
              reason: 'Should see replay icon, because recording is completed',
            );
          },
          expectedEvents: [],
        );

        await tester.screenshot(
          description: 'replay',
          arrangeBeforeActions: (arrange) {
            final playAudioEffect = arrange.mocks.playAudioEffects
                .firstWhere((e) => e.debugLabel == 'recording1');

            when(playAudioEffect.replay).thenAnswer((invocation) async {
              playAudioEffect.streamController
                  ?.add(PlayerState(true, ProcessingState.ready));
            });
          },
          actions: (actions) async {
            await actions.userAction.tap(
              find.descendant(
                of: find.byType(HomeC_PlayAudioButtons),
                matching: find.byKey(const Key('recording1')),
              ),
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.ancestor(
                of: find.text('recording1'),
                matching: find.byKey(const Key('pause')),
              ),
              findsOneWidget,
              reason: 'Should see pause icon, because recording is replaying',
            );
          },
          expectedEvents: [],
        );
      },
    );

    group('error', () {
      final errorDescription = FTDescription(
        descriptionType: 'AC',
        directoryName: 'error',
        description: '''Is error''',
      );
      flowTest(
        'not played',
        config: createFlowConfig(
          hasAccessToken: true,
        ),
        descriptions: [
          ...baseDescriptions,
          errorDescription,
          FTDescription(
            descriptionType: 'STATUS',
            directoryName: 'not_played',
            description: 'Could not play recording',
          ),
        ],
        test: (tester) async {
          await tester.setUp(
            arrangeBeforePumpApp: (arrange) async {
              await arrangeBeforeWarpToHome(arrange);

              // -- Overwrite
              when(
                () => arrange.mocks.audioRepository
                    .getMyRecordingsStream(userId: any(named: 'userId')),
              ).thenAnswer((invocation) async {
                return Stream.fromIterable([
                  [
                    {
                      'path_tokens': ['userId1', 'recording1'],
                    },
                    {
                      'path_tokens': ['userId2', 'recording2'],
                    },
                  ],
                ]);
              });

              when(
                () => arrange.mocks.audioRepository.getSignedRecordingUrls(
                  recordingNames: any(named: 'recordingNames'),
                ),
              ).thenAnswer((invocation) async {
                return [
                  const SignedUrl(
                    path: 'userId1/recording1',
                    signedUrl: 'fakeSignedUrl1',
                  ),
                  const SignedUrl(
                    path: 'userId2/recording2',
                    signedUrl: 'fakeSignedUrl2',
                  ),
                ];
              });

              when(
                () => arrange.mocks.uuidEffect
                    .generateUuidV4(debugLabel: any(named: 'debugLabel')),
              ).thenAnswer((invocation) {
                final uuid = invocation
                    .namedArguments[const Symbol('debugLabel')] as String;
                return uuid;
              });
            },
          );

          await tester.screenshot(
            description: 'initial state',
            actions: (actions) async {
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.text('recording1'),
                findsOneWidget,
                reason: 'Should see recording 1',
              );
              expectations.expect(
                find.text('recording2'),
                findsOneWidget,
                reason: 'Should see recording 2',
              );
            },
            expectedEvents: [
              'INFO: [router] deeplink: /',
              'Page: Home',
              RecordingsEvent_GetMyRecordings,
              RecordingsEvent_SetMyRecordings,
            ],
          );

          await tester.screenshot(
            description: 'play recording 1',
            arrangeBeforeActions: (arrange) {
              final playAudioEffect = arrange.mocks.playAudioEffects
                  .firstWhere((e) => e.debugLabel == 'recording1');

              when(() => playAudioEffect.setUrl(url: any(named: 'url')))
                  .thenAnswer((invocation) async {});

              when(playAudioEffect.play).thenThrow(Exception('BOOM'));
            },
            actions: (actions) async {
              await actions.userAction.tap(
                find.descendant(
                  of: find.byType(HomeC_PlayAudioButtons),
                  matching: find.byKey(const Key('recording1')),
                ),
              );
              await actions.testerAction.pumpAndSettle();
            },
            expectedEvents: [
              'WARNING: [play_audio_effect] could not play',
              RecordingsEvent_PlayingError,
            ],
          );
        },
      );

      flowTest(
        'not paused',
        config: createFlowConfig(
          hasAccessToken: true,
        ),
        descriptions: [
          ...baseDescriptions,
          errorDescription,
          FTDescription(
            descriptionType: 'STATUS',
            directoryName: 'not_paused',
            description: 'Could not pause recording',
          ),
        ],
        test: (tester) async {
          await tester.setUp(
            arrangeBeforePumpApp: (arrange) async {
              await arrangeBeforeWarpToHome(arrange);

              // -- Overwrite
              when(
                () => arrange.mocks.audioRepository
                    .getMyRecordingsStream(userId: any(named: 'userId')),
              ).thenAnswer((invocation) async {
                return Stream.fromIterable([
                  [
                    {
                      'path_tokens': ['userId1', 'recording1'],
                    },
                    {
                      'path_tokens': ['userId2', 'recording2'],
                    },
                  ],
                ]);
              });

              when(
                () => arrange.mocks.audioRepository.getSignedRecordingUrls(
                  recordingNames: any(named: 'recordingNames'),
                ),
              ).thenAnswer((invocation) async {
                return [
                  const SignedUrl(
                    path: 'userId1/recording1',
                    signedUrl: 'fakeSignedUrl1',
                  ),
                  const SignedUrl(
                    path: 'userId2/recording2',
                    signedUrl: 'fakeSignedUrl2',
                  ),
                ];
              });

              when(
                () => arrange.mocks.uuidEffect
                    .generateUuidV4(debugLabel: any(named: 'debugLabel')),
              ).thenAnswer((invocation) {
                final uuid = invocation
                    .namedArguments[const Symbol('debugLabel')] as String;
                return uuid;
              });
            },
          );

          await tester.screenshot(
            description: 'initial state',
            actions: (actions) async {
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.text('recording1'),
                findsOneWidget,
                reason: 'Should see recording 1',
              );
              expectations.expect(
                find.text('recording2'),
                findsOneWidget,
                reason: 'Should see recording 2',
              );
            },
            expectedEvents: [
              'INFO: [router] deeplink: /',
              'Page: Home',
              RecordingsEvent_GetMyRecordings,
              RecordingsEvent_SetMyRecordings,
            ],
          );

          await tester.screenshot(
            description: 'play recording 1 (pump half)',
            arrangeBeforeActions: (arrange) {
              final playAudioEffect = arrange.mocks.playAudioEffects
                  .firstWhere((e) => e.debugLabel == 'recording1');

              when(() => playAudioEffect.setUrl(url: any(named: 'url')))
                  .thenAnswer((invocation) async {});

              when(playAudioEffect.play).thenAnswer((invocation) async {
                playAudioEffect.streamController
                    ?.add(PlayerState(false, ProcessingState.loading));
              });
            },
            actions: (actions) async {
              await actions.userAction.tap(
                find.descendant(
                  of: find.byType(HomeC_PlayAudioButtons),
                  matching: find.byKey(const Key('recording1')),
                ),
              );
              await actions.testerAction
                  .pump(const Duration(milliseconds: 300));
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('loading')),
                findsOneWidget,
                reason: 'Should see loading icon',
              );
            },
            expectedEvents: [],
          );

          await tester.screenshot(
            description: 'play recording 1 (pump rest)',
            arrangeBeforeActions: (arrange) {
              final playAudioEffect = arrange.mocks.playAudioEffects
                  .firstWhere((e) => e.debugLabel == 'recording1');

              playAudioEffect.streamController
                  ?.add(PlayerState(true, ProcessingState.ready));
            },
            actions: (actions) async {
              await actions.testerAction
                  .pump(const Duration(milliseconds: 300));
            },
            expectations: (expectations) {
              expectations.expect(
                find.ancestor(
                  of: find.text('recording1'),
                  matching: find.byKey(const Key('pause')),
                ),
                findsOneWidget,
                reason: 'Should see pause icon because recording is playing',
              );
            },
            expectedEvents: [],
          );

          await tester.screenshot(
            description: 'pause',
            arrangeBeforeActions: (arrange) {
              final playAudioEffect = arrange.mocks.playAudioEffects
                  .firstWhere((e) => e.debugLabel == 'recording1');

              when(playAudioEffect.pause).thenThrow(Exception('BOOM'));
            },
            actions: (actions) async {
              await actions.userAction.tap(
                find.descendant(
                  of: find.byType(HomeC_PlayAudioButtons),
                  matching: find.byKey(const Key('recording1')),
                ),
              );
              await actions.testerAction.pumpAndSettle();
            },
            expectedEvents: [
              'WARNING: [play_audio_effect] could not pause',
              RecordingsEvent_PlayingError,
            ],
          );
        },
      );

      flowTest(
        'not resumed',
        config: createFlowConfig(
          hasAccessToken: true,
        ),
        descriptions: [
          ...baseDescriptions,
          errorDescription,
          FTDescription(
            descriptionType: 'STATUS',
            directoryName: 'not_resumed',
            description: 'Could not resume recording',
          ),
        ],
        test: (tester) async {
          await tester.setUp(
            arrangeBeforePumpApp: (arrange) async {
              await arrangeBeforeWarpToHome(arrange);

              // -- Overwrite
              when(
                () => arrange.mocks.audioRepository
                    .getMyRecordingsStream(userId: any(named: 'userId')),
              ).thenAnswer((invocation) async {
                return Stream.fromIterable([
                  [
                    {
                      'path_tokens': ['userId1', 'recording1'],
                    },
                    {
                      'path_tokens': ['userId2', 'recording2'],
                    },
                  ],
                ]);
              });

              when(
                () => arrange.mocks.audioRepository.getSignedRecordingUrls(
                  recordingNames: any(named: 'recordingNames'),
                ),
              ).thenAnswer((invocation) async {
                return [
                  const SignedUrl(
                    path: 'userId1/recording1',
                    signedUrl: 'fakeSignedUrl1',
                  ),
                  const SignedUrl(
                    path: 'userId2/recording2',
                    signedUrl: 'fakeSignedUrl2',
                  ),
                ];
              });

              when(
                () => arrange.mocks.uuidEffect
                    .generateUuidV4(debugLabel: any(named: 'debugLabel')),
              ).thenAnswer((invocation) {
                final uuid = invocation
                    .namedArguments[const Symbol('debugLabel')] as String;
                return uuid;
              });
            },
          );

          await tester.screenshot(
            description: 'initial state',
            actions: (actions) async {
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.text('recording1'),
                findsOneWidget,
                reason: 'Should see recording 1',
              );
              expectations.expect(
                find.text('recording2'),
                findsOneWidget,
                reason: 'Should see recording 2',
              );
            },
            expectedEvents: [
              'INFO: [router] deeplink: /',
              'Page: Home',
              RecordingsEvent_GetMyRecordings,
              RecordingsEvent_SetMyRecordings,
            ],
          );

          await tester.screenshot(
            description: 'play recording 1 (pump half)',
            arrangeBeforeActions: (arrange) {
              final playAudioEffect = arrange.mocks.playAudioEffects
                  .firstWhere((e) => e.debugLabel == 'recording1');

              when(() => playAudioEffect.setUrl(url: any(named: 'url')))
                  .thenAnswer((invocation) async {});

              when(playAudioEffect.play).thenAnswer((invocation) async {
                playAudioEffect.streamController
                    ?.add(PlayerState(false, ProcessingState.loading));
              });
            },
            actions: (actions) async {
              await actions.userAction.tap(
                find.descendant(
                  of: find.byType(HomeC_PlayAudioButtons),
                  matching: find.byKey(const Key('recording1')),
                ),
              );
              await actions.testerAction
                  .pump(const Duration(milliseconds: 300));
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('loading')),
                findsOneWidget,
                reason: 'Should see loading icon',
              );
            },
            expectedEvents: [],
          );

          await tester.screenshot(
            description: 'play recording 1 (pump rest)',
            arrangeBeforeActions: (arrange) {
              final playAudioEffect = arrange.mocks.playAudioEffects
                  .firstWhere((e) => e.debugLabel == 'recording1');

              playAudioEffect.streamController
                  ?.add(PlayerState(true, ProcessingState.ready));
            },
            actions: (actions) async {
              await actions.testerAction
                  .pump(const Duration(milliseconds: 300));
            },
            expectations: (expectations) {
              expectations.expect(
                find.ancestor(
                  of: find.text('recording1'),
                  matching: find.byKey(const Key('pause')),
                ),
                findsOneWidget,
                reason: 'Should see pause icon because recording is playing',
              );
            },
            expectedEvents: [],
          );

          await tester.screenshot(
            description: 'pause',
            arrangeBeforeActions: (arrange) {
              final playAudioEffect = arrange.mocks.playAudioEffects
                  .firstWhere((e) => e.debugLabel == 'recording1');

              when(playAudioEffect.pause).thenAnswer((invocation) async {
                playAudioEffect.streamController
                    ?.add(PlayerState(false, ProcessingState.ready));
              });
            },
            actions: (actions) async {
              await actions.userAction.tap(
                find.descendant(
                  of: find.byType(HomeC_PlayAudioButtons),
                  matching: find.byKey(const Key('recording1')),
                ),
              );
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.ancestor(
                  of: find.text('recording1'),
                  matching: find.byKey(const Key('resume')),
                ),
                findsOneWidget,
                reason: 'Should see resume icon, because recording is paused',
              );
            },
            expectedEvents: [],
          );

          await tester.screenshot(
            description: 'resume',
            arrangeBeforeActions: (arrange) {
              final playAudioEffect = arrange.mocks.playAudioEffects
                  .firstWhere((e) => e.debugLabel == 'recording1');

              when(playAudioEffect.play).thenThrow(Exception('BOOM'));
            },
            actions: (actions) async {
              await actions.userAction.tap(
                find.descendant(
                  of: find.byType(HomeC_PlayAudioButtons),
                  matching: find.byKey(const Key('recording1')),
                ),
              );
              await actions.testerAction.pumpAndSettle();
            },
            expectedEvents: [
              'WARNING: [play_audio_effect] could not play',
              RecordingsEvent_PlayingError,
            ],
          );
        },
      );

      flowTest(
        'not replayed',
        config: createFlowConfig(
          hasAccessToken: true,
        ),
        descriptions: [
          ...baseDescriptions,
          errorDescription,
          FTDescription(
            descriptionType: 'STATUS',
            directoryName: 'not_replayed',
            description: 'Could not replay recording',
          ),
        ],
        test: (tester) async {
          await tester.setUp(
            arrangeBeforePumpApp: (arrange) async {
              await arrangeBeforeWarpToHome(arrange);

              // -- Overwrite
              when(
                () => arrange.mocks.audioRepository
                    .getMyRecordingsStream(userId: any(named: 'userId')),
              ).thenAnswer((invocation) async {
                return Stream.fromIterable([
                  [
                    {
                      'path_tokens': ['userId1', 'recording1'],
                    },
                    {
                      'path_tokens': ['userId2', 'recording2'],
                    },
                  ],
                ]);
              });

              when(
                () => arrange.mocks.audioRepository.getSignedRecordingUrls(
                  recordingNames: any(named: 'recordingNames'),
                ),
              ).thenAnswer((invocation) async {
                return [
                  const SignedUrl(
                    path: 'userId1/recording1',
                    signedUrl: 'fakeSignedUrl1',
                  ),
                  const SignedUrl(
                    path: 'userId2/recording2',
                    signedUrl: 'fakeSignedUrl2',
                  ),
                ];
              });

              when(
                () => arrange.mocks.uuidEffect
                    .generateUuidV4(debugLabel: any(named: 'debugLabel')),
              ).thenAnswer((invocation) {
                final uuid = invocation
                    .namedArguments[const Symbol('debugLabel')] as String;
                return uuid;
              });
            },
          );

          await tester.screenshot(
            description: 'initial state',
            actions: (actions) async {
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.text('recording1'),
                findsOneWidget,
                reason: 'Should see recording 1',
              );
              expectations.expect(
                find.text('recording2'),
                findsOneWidget,
                reason: 'Should see recording 2',
              );
            },
            expectedEvents: [
              'INFO: [router] deeplink: /',
              'Page: Home',
              RecordingsEvent_GetMyRecordings,
              RecordingsEvent_SetMyRecordings,
            ],
          );

          await tester.screenshot(
            description: 'play recording 1 (pump half)',
            arrangeBeforeActions: (arrange) {
              final playAudioEffect = arrange.mocks.playAudioEffects
                  .firstWhere((e) => e.debugLabel == 'recording1');

              when(() => playAudioEffect.setUrl(url: any(named: 'url')))
                  .thenAnswer((invocation) async {});

              when(playAudioEffect.play).thenAnswer((invocation) async {
                playAudioEffect.streamController
                    ?.add(PlayerState(false, ProcessingState.loading));
              });
            },
            actions: (actions) async {
              await actions.userAction.tap(
                find.descendant(
                  of: find.byType(HomeC_PlayAudioButtons),
                  matching: find.byKey(const Key('recording1')),
                ),
              );
              await actions.testerAction
                  .pump(const Duration(milliseconds: 300));
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('loading')),
                findsOneWidget,
                reason: 'Should see loading icon',
              );
            },
            expectedEvents: [],
          );

          await tester.screenshot(
            description: 'play recording 1 (pump rest)',
            arrangeBeforeActions: (arrange) {
              final playAudioEffect = arrange.mocks.playAudioEffects
                  .firstWhere((e) => e.debugLabel == 'recording1');

              playAudioEffect.streamController
                  ?.add(PlayerState(true, ProcessingState.ready));
            },
            actions: (actions) async {
              await actions.testerAction
                  .pump(const Duration(milliseconds: 300));
            },
            expectations: (expectations) {
              expectations.expect(
                find.ancestor(
                  of: find.text('recording1'),
                  matching: find.byKey(const Key('pause')),
                ),
                findsOneWidget,
                reason: 'Should see pause icon because recording is playing',
              );
            },
            expectedEvents: [],
          );

          await tester.screenshot(
            description: 'pause',
            arrangeBeforeActions: (arrange) {
              final playAudioEffect = arrange.mocks.playAudioEffects
                  .firstWhere((e) => e.debugLabel == 'recording1');

              when(playAudioEffect.pause).thenAnswer((invocation) async {
                playAudioEffect.streamController
                    ?.add(PlayerState(false, ProcessingState.ready));
              });
            },
            actions: (actions) async {
              await actions.userAction.tap(
                find.descendant(
                  of: find.byType(HomeC_PlayAudioButtons),
                  matching: find.byKey(const Key('recording1')),
                ),
              );
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.ancestor(
                  of: find.text('recording1'),
                  matching: find.byKey(const Key('resume')),
                ),
                findsOneWidget,
                reason: 'Should see resume icon, because recording is paused',
              );
            },
            expectedEvents: [],
          );

          await tester.screenshot(
            description: 'resume',
            arrangeBeforeActions: (arrange) {
              final playAudioEffect = arrange.mocks.playAudioEffects
                  .firstWhere((e) => e.debugLabel == 'recording1');

              when(playAudioEffect.play).thenAnswer((invocation) async {
                playAudioEffect.streamController
                    ?.add(PlayerState(true, ProcessingState.completed));
              });
            },
            actions: (actions) async {
              await actions.userAction.tap(
                find.descendant(
                  of: find.byType(HomeC_PlayAudioButtons),
                  matching: find.byKey(const Key('recording1')),
                ),
              );
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.ancestor(
                  of: find.text('recording1'),
                  matching: find.byKey(const Key('replay')),
                ),
                findsOneWidget,
                reason:
                    'Should see replay icon, because recording is completed',
              );
            },
            expectedEvents: [],
          );

          await tester.screenshot(
            description: 'replay',
            arrangeBeforeActions: (arrange) {
              final playAudioEffect = arrange.mocks.playAudioEffects
                  .firstWhere((e) => e.debugLabel == 'recording1');

              when(playAudioEffect.replay).thenThrow(Exception('BOOM'));
            },
            actions: (actions) async {
              await actions.userAction.tap(
                find.descendant(
                  of: find.byType(HomeC_PlayAudioButtons),
                  matching: find.byKey(const Key('recording1')),
                ),
              );
              await actions.testerAction.pumpAndSettle();
            },
            expectedEvents: [
              'WARNING: [play_audio_effect] could not replay',
              RecordingsEvent_PlayingError,
            ],
          );
        },
      );
    });
  });
}
