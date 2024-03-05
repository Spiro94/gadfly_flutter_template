import 'dart:typed_data';
import 'package:flow_test/flow_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;
import 'package:gadfly_flutter_template/blocs/record_audio/event.dart';
import 'package:gadfly_flutter_template/blocs/recordings/event.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';

import '../../util/flow_config.dart';
import '../../util/warp/to_home.dart';

void main() {
  final baseDescriptions = [
    FTDescription(
      descriptionType: 'EPIC',
      shortDescription: 'audio',
      description: '''As a user, I need to be able to record and play audio.''',
    ),
    FTDescription(
      descriptionType: 'STORY',
      shortDescription: 'record',
      description: '''As a user, I should be able to record and save''',
      atScreenshotsLevel: true,
    ),
  ];

  group('record', () {
    flowTest(
      'success',
      config: createFlowConfig(
        hasAccessToken: true,
      ),
      descriptions: [
        ...baseDescriptions,
        FTDescription(
          descriptionType: 'AC',
          shortDescription: 'success',
          description: '''Is successful''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: (arrange) async {
            await arrangeBeforeWarpToHome(arrange);
          },
        );

        await tester.screenshot(
          description: 'initial state',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {},
          expectedEvents: [
            'INFO: [router] deeplink: /',
            'Page: Home',
            RecordingsEvent_GetMyRecordings,
          ],
        );

        await tester.screenshot(
          description: 'tap record',
          arrangeBeforeActions: (arrange) {
            when(
              () => arrange.mocks.recordAudioEffect.start(),
            ).thenAnswer((invocation) async {});
          },
          actions: (actions) async {
            await actions.userAction.tap(find.byKey(const Key('RecordButton')));
            await actions.testerAction.pump();
            await actions.testerAction.pump(const Duration(milliseconds: 500));
          },
          expectations: (expectations) {
            expectations.expect(
              find.byKey(const Key('LoadingButton')),
              findsOneWidget,
              reason: 'Should see loading button',
            );
          },
          expectedEvents: [
            RecordAudioEvent_Record,
          ],
        );

        await tester.screenshot(
          description: 'recording started',
          arrangeBeforeActions: (arrange) {
            arrange.mocks.recordAudioEffect.streamController
                ?.add(RecordState.record);
          },
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byKey(const Key('PauseButton')),
              findsOneWidget,
              reason: 'Should see pause button',
            );
            expectations.expect(
              find.byKey(const Key('StopButton')),
              findsOneWidget,
              reason: 'Should see stop button',
            );
          },
          expectedEvents: [],
        );

        await tester.screenshot(
          description: 'tap pause button',
          arrangeBeforeActions: (arrange) {
            when(arrange.mocks.recordAudioEffect.pause)
                .thenAnswer((invocation) async {
              arrange.mocks.recordAudioEffect.streamController
                  ?.add(RecordState.pause);
            });
          },
          actions: (actions) async {
            await actions.userAction.tap(find.byKey(const Key('PauseButton')));
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byKey(const Key('ResumeButton')),
              findsOneWidget,
              reason: 'Should see resume button',
            );
          },
          expectedEvents: [
            RecordAudioEvent_Pause,
          ],
        );

        await tester.screenshot(
          description: 'tap resume',
          arrangeBeforeActions: (arrange) {
            when(arrange.mocks.recordAudioEffect.resume)
                .thenAnswer((invocation) async {
              arrange.mocks.recordAudioEffect.streamController
                  ?.add(RecordState.record);
            });
          },
          actions: (actions) async {
            await actions.userAction.tap(find.byKey(const Key('ResumeButton')));
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byKey(const Key('PauseButton')),
              findsOneWidget,
              reason: 'Should see pause button',
            );
            expectations.expect(
              find.byKey(const Key('StopButton')),
              findsOneWidget,
              reason: 'Should see stop button',
            );
          },
          expectedEvents: [
            RecordAudioEvent_Resume,
          ],
        );

        await tester.screenshot(
          description: 'tap stop',
          arrangeBeforeActions: (arrange) {
            when(arrange.mocks.recordAudioEffect.stop)
                .thenAnswer((invocation) async {
              arrange.mocks.recordAudioEffect.streamController
                  ?.add(RecordState.stop);
              return '';
            });

            when(
              () => arrange.mocks.nowEffect
                  .now(debugLabel: 'RecordAudioEvent_Save'),
            ).thenAnswer(
              (invocation) => DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
            );

            when(
              () => arrange.mocks.authRepository.getUserId(),
            ).thenAnswer((invocation) async => 'fakeUserId');

            registerFallbackValue(Uint8List.fromList([]));
            when(
              () => arrange.mocks.recordAudioEffect
                  .getFileBytes(recordingPath: any(named: 'recordingPath')),
            ).thenAnswer(
              (invocation) async {
                return Uint8List.fromList(
                  // just over 4kb limit
                  List.generate(4097, (index) => index),
                );
              },
            );
            when(
              () => arrange.mocks.audioRepository.recordingSave(
                recordingName: any(named: 'recordingName'),
                recordingBytes: any(named: 'recordingBytes'),
              ),
            ).thenAnswer((invocation) async {});
          },
          actions: (actions) async {
            await actions.userAction.tap(find.byKey(const Key('StopButton')));
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byKey(const Key('RecordButton')),
              findsOneWidget,
              reason: 'Should see record button',
            );
          },
          expectedEvents: [
            RecordAudioEvent_Stop,
            RecordAudioEvent_Save,
          ],
        );
      },
    );

    group('error', () {
      final errorDescription = FTDescription(
        descriptionType: 'AC',
        shortDescription: 'error',
        description: '''Is error''',
      );
      flowTest(
        'recording was not started',
        config: createFlowConfig(
          hasAccessToken: true,
        ),
        descriptions: [
          ...baseDescriptions,
          errorDescription,
          FTDescription(
            description: 'Recording was not started',
            descriptionType: 'ERROR',
            shortDescription: 'not_started',
          ),
        ],
        test: (tester) async {
          await tester.setUp(
            arrangeBeforePumpApp: (arrange) async {
              await arrangeBeforeWarpToHome(arrange);
            },
          );

          await tester.screenshot(
            description: 'initial state',
            actions: (actions) async {
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {},
            expectedEvents: [
              'INFO: [router] deeplink: /',
              'Page: Home',
              RecordingsEvent_GetMyRecordings,
            ],
          );

          await tester.screenshot(
            description: 'tap record',
            arrangeBeforeActions: (arrange) {
              when(arrange.mocks.recordAudioEffect.start)
                  .thenThrow(Exception('BOOM'));
            },
            actions: (actions) async {
              await actions.userAction
                  .tap(find.byKey(const Key('RecordButton')));
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('RecordButton')),
                findsOneWidget,
                reason: 'Should see record button',
              );
              expectations.expect(
                find.text('Uh oh, something went wrong.'),
                findsOneWidget,
                reason: 'Should see error snackbar',
              );
            },
            expectedEvents: [
              RecordAudioEvent_Record,
              '''WARNING: [record_audio_effect] recording was not started''',
              RecordAudioEvent_Error,
            ],
          );
        },
      );

      flowTest(
        'recording was not paused',
        config: createFlowConfig(
          hasAccessToken: true,
        ),
        descriptions: [
          ...baseDescriptions,
          errorDescription,
          FTDescription(
            description: 'Recording was not paused',
            descriptionType: 'ERROR',
            shortDescription: 'not_paused',
          ),
        ],
        test: (tester) async {
          await tester.setUp(
            arrangeBeforePumpApp: (arrange) async {
              await arrangeBeforeWarpToHome(arrange);
            },
          );

          await tester.screenshot(
            description: 'initial state',
            actions: (actions) async {
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {},
            expectedEvents: [
              'INFO: [router] deeplink: /',
              'Page: Home',
              RecordingsEvent_GetMyRecordings,
            ],
          );

          await tester.screenshot(
            description: 'tap record',
            arrangeBeforeActions: (arrange) {
              when(
                () => arrange.mocks.recordAudioEffect.start(),
              ).thenAnswer((invocation) async {});
            },
            actions: (actions) async {
              await actions.userAction
                  .tap(find.byKey(const Key('RecordButton')));
              await actions.testerAction.pump();
              await actions.testerAction
                  .pump(const Duration(milliseconds: 500));
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('LoadingButton')),
                findsOneWidget,
                reason: 'Should see loading button',
              );
            },
            expectedEvents: [
              RecordAudioEvent_Record,
            ],
          );

          await tester.screenshot(
            description: 'recording started',
            arrangeBeforeActions: (arrange) {
              arrange.mocks.recordAudioEffect.streamController
                  ?.add(RecordState.record);
            },
            actions: (actions) async {
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('PauseButton')),
                findsOneWidget,
                reason: 'Should see pause button',
              );
              expectations.expect(
                find.byKey(const Key('StopButton')),
                findsOneWidget,
                reason: 'Should see stop button',
              );
            },
            expectedEvents: [],
          );

          await tester.screenshot(
            description: 'tap pause button',
            arrangeBeforeActions: (arrange) {
              when(arrange.mocks.recordAudioEffect.pause)
                  .thenThrow(Exception('BOOM'));
            },
            actions: (actions) async {
              await actions.userAction
                  .tap(find.byKey(const Key('PauseButton')));
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('RecordButton')),
                findsOneWidget,
                reason: 'Should see record button',
              );
              expectations.expect(
                find.text('Uh oh, something went wrong.'),
                findsOneWidget,
                reason: 'Should see error snackbar',
              );
            },
            expectedEvents: [
              RecordAudioEvent_Pause,
              '''WARNING: [record_audio_effect] recording was not paused''',
              RecordAudioEvent_Error,
            ],
          );
        },
      );

      flowTest(
        'recording was not resumed',
        config: createFlowConfig(
          hasAccessToken: true,
        ),
        descriptions: [
          ...baseDescriptions,
          errorDescription,
          FTDescription(
            description: 'Recording was not resumed',
            descriptionType: 'ERROR',
            shortDescription: 'not_resumed',
          ),
        ],
        test: (tester) async {
          await tester.setUp(
            arrangeBeforePumpApp: (arrange) async {
              await arrangeBeforeWarpToHome(arrange);
            },
          );

          await tester.screenshot(
            description: 'initial state',
            actions: (actions) async {
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {},
            expectedEvents: [
              'INFO: [router] deeplink: /',
              'Page: Home',
              RecordingsEvent_GetMyRecordings,
            ],
          );

          await tester.screenshot(
            description: 'tap record',
            arrangeBeforeActions: (arrange) {
              when(
                () => arrange.mocks.recordAudioEffect.start(),
              ).thenAnswer((invocation) async {});
            },
            actions: (actions) async {
              await actions.userAction
                  .tap(find.byKey(const Key('RecordButton')));
              await actions.testerAction.pump();
              await actions.testerAction
                  .pump(const Duration(milliseconds: 500));
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('LoadingButton')),
                findsOneWidget,
                reason: 'Should see loading button',
              );
            },
            expectedEvents: [
              RecordAudioEvent_Record,
            ],
          );

          await tester.screenshot(
            description: 'recording started',
            arrangeBeforeActions: (arrange) {
              arrange.mocks.recordAudioEffect.streamController
                  ?.add(RecordState.record);
            },
            actions: (actions) async {
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('PauseButton')),
                findsOneWidget,
                reason: 'Should see pause button',
              );
              expectations.expect(
                find.byKey(const Key('StopButton')),
                findsOneWidget,
                reason: 'Should see stop button',
              );
            },
            expectedEvents: [],
          );

          await tester.screenshot(
            description: 'tap pause button',
            arrangeBeforeActions: (arrange) {
              when(arrange.mocks.recordAudioEffect.pause)
                  .thenAnswer((invocation) async {
                arrange.mocks.recordAudioEffect.streamController
                    ?.add(RecordState.pause);
              });
            },
            actions: (actions) async {
              await actions.userAction
                  .tap(find.byKey(const Key('PauseButton')));
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('ResumeButton')),
                findsOneWidget,
                reason: 'Should see resume button',
              );
            },
            expectedEvents: [
              RecordAudioEvent_Pause,
            ],
          );

          await tester.screenshot(
            description: 'tap resume',
            arrangeBeforeActions: (arrange) {
              when(arrange.mocks.recordAudioEffect.resume)
                  .thenThrow(Exception('BOOM'));
            },
            actions: (actions) async {
              await actions.userAction
                  .tap(find.byKey(const Key('ResumeButton')));
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('RecordButton')),
                findsOneWidget,
                reason: 'Should see record button',
              );
              expectations.expect(
                find.text('Uh oh, something went wrong.'),
                findsOneWidget,
                reason: 'Should see error snackbar',
              );
            },
            expectedEvents: [
              RecordAudioEvent_Resume,
              '''WARNING: [record_audio_effect] recording was not resumed''',
              RecordAudioEvent_Error,
            ],
          );
        },
      );

      flowTest(
        'recording was not stopped',
        config: createFlowConfig(
          hasAccessToken: true,
        ),
        descriptions: [
          ...baseDescriptions,
          errorDescription,
          FTDescription(
            description: 'Recording was not stopped',
            descriptionType: 'ERROR',
            shortDescription: 'not_stopped',
          ),
        ],
        test: (tester) async {
          await tester.setUp(
            arrangeBeforePumpApp: (arrange) async {
              await arrangeBeforeWarpToHome(arrange);
            },
          );

          await tester.screenshot(
            description: 'initial state',
            actions: (actions) async {
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {},
            expectedEvents: [
              'INFO: [router] deeplink: /',
              'Page: Home',
              RecordingsEvent_GetMyRecordings,
            ],
          );

          await tester.screenshot(
            description: 'tap record',
            arrangeBeforeActions: (arrange) {
              when(
                () => arrange.mocks.recordAudioEffect.start(),
              ).thenAnswer((invocation) async {});
            },
            actions: (actions) async {
              await actions.userAction
                  .tap(find.byKey(const Key('RecordButton')));
              await actions.testerAction.pump();
              await actions.testerAction
                  .pump(const Duration(milliseconds: 500));
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('LoadingButton')),
                findsOneWidget,
                reason: 'Should see loading button',
              );
            },
            expectedEvents: [
              RecordAudioEvent_Record,
            ],
          );

          await tester.screenshot(
            description: 'recording started',
            arrangeBeforeActions: (arrange) {
              arrange.mocks.recordAudioEffect.streamController
                  ?.add(RecordState.record);
            },
            actions: (actions) async {
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('PauseButton')),
                findsOneWidget,
                reason: 'Should see pause button',
              );
              expectations.expect(
                find.byKey(const Key('StopButton')),
                findsOneWidget,
                reason: 'Should see stop button',
              );
            },
            expectedEvents: [],
          );

          await tester.screenshot(
            description: 'tap pause button',
            arrangeBeforeActions: (arrange) {
              when(arrange.mocks.recordAudioEffect.pause)
                  .thenAnswer((invocation) async {
                arrange.mocks.recordAudioEffect.streamController
                    ?.add(RecordState.pause);
              });
            },
            actions: (actions) async {
              await actions.userAction
                  .tap(find.byKey(const Key('PauseButton')));
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('ResumeButton')),
                findsOneWidget,
                reason: 'Should see resume button',
              );
            },
            expectedEvents: [
              RecordAudioEvent_Pause,
            ],
          );

          await tester.screenshot(
            description: 'tap resume',
            arrangeBeforeActions: (arrange) {
              when(arrange.mocks.recordAudioEffect.resume)
                  .thenAnswer((invocation) async {
                arrange.mocks.recordAudioEffect.streamController
                    ?.add(RecordState.record);
              });
            },
            actions: (actions) async {
              await actions.userAction
                  .tap(find.byKey(const Key('ResumeButton')));
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('PauseButton')),
                findsOneWidget,
                reason: 'Should see pause button',
              );
              expectations.expect(
                find.byKey(const Key('StopButton')),
                findsOneWidget,
                reason: 'Should see stop button',
              );
            },
            expectedEvents: [
              RecordAudioEvent_Resume,
            ],
          );

          await tester.screenshot(
            description: 'tap stop',
            arrangeBeforeActions: (arrange) {
              when(arrange.mocks.recordAudioEffect.stop)
                  .thenThrow(Exception('BOOM'));
            },
            actions: (actions) async {
              await actions.userAction.tap(find.byKey(const Key('StopButton')));
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('RecordButton')),
                findsOneWidget,
                reason: 'Should see record button',
              );
              expectations.expect(
                find.text('Uh oh, something went wrong.'),
                findsOneWidget,
                reason: 'Should see error snackbar',
              );
            },
            expectedEvents: [
              RecordAudioEvent_Stop,
              '''WARNING: [record_audio_effect] recording was not stopped''',
              RecordAudioEvent_Error,
            ],
          );
        },
      );

      flowTest(
        'recording was not saved',
        config: createFlowConfig(
          hasAccessToken: true,
        ),
        descriptions: [
          ...baseDescriptions,
          errorDescription,
          FTDescription(
            description: 'Recording was not saved',
            descriptionType: 'ERROR',
            shortDescription: 'not_saved',
          ),
        ],
        test: (tester) async {
          await tester.setUp(
            arrangeBeforePumpApp: (arrange) async {
              await arrangeBeforeWarpToHome(arrange);
            },
          );

          await tester.screenshot(
            description: 'initial state',
            actions: (actions) async {
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {},
            expectedEvents: [
              'INFO: [router] deeplink: /',
              'Page: Home',
              RecordingsEvent_GetMyRecordings,
            ],
          );

          await tester.screenshot(
            description: 'tap record',
            arrangeBeforeActions: (arrange) {
              when(
                () => arrange.mocks.recordAudioEffect.start(),
              ).thenAnswer((invocation) async {});
            },
            actions: (actions) async {
              await actions.userAction
                  .tap(find.byKey(const Key('RecordButton')));
              await actions.testerAction.pump();
              await actions.testerAction
                  .pump(const Duration(milliseconds: 500));
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('LoadingButton')),
                findsOneWidget,
                reason: 'Should see loading button',
              );
            },
            expectedEvents: [
              RecordAudioEvent_Record,
            ],
          );

          await tester.screenshot(
            description: 'recording started',
            arrangeBeforeActions: (arrange) {
              arrange.mocks.recordAudioEffect.streamController
                  ?.add(RecordState.record);
            },
            actions: (actions) async {
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('PauseButton')),
                findsOneWidget,
                reason: 'Should see pause button',
              );
              expectations.expect(
                find.byKey(const Key('StopButton')),
                findsOneWidget,
                reason: 'Should see stop button',
              );
            },
            expectedEvents: [],
          );

          await tester.screenshot(
            description: 'tap pause button',
            arrangeBeforeActions: (arrange) {
              when(arrange.mocks.recordAudioEffect.pause)
                  .thenAnswer((invocation) async {
                arrange.mocks.recordAudioEffect.streamController
                    ?.add(RecordState.pause);
              });
            },
            actions: (actions) async {
              await actions.userAction
                  .tap(find.byKey(const Key('PauseButton')));
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('ResumeButton')),
                findsOneWidget,
                reason: 'Should see resume button',
              );
            },
            expectedEvents: [
              RecordAudioEvent_Pause,
            ],
          );

          await tester.screenshot(
            description: 'tap resume',
            arrangeBeforeActions: (arrange) {
              when(arrange.mocks.recordAudioEffect.resume)
                  .thenAnswer((invocation) async {
                arrange.mocks.recordAudioEffect.streamController
                    ?.add(RecordState.record);
              });
            },
            actions: (actions) async {
              await actions.userAction
                  .tap(find.byKey(const Key('ResumeButton')));
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('PauseButton')),
                findsOneWidget,
                reason: 'Should see pause button',
              );
              expectations.expect(
                find.byKey(const Key('StopButton')),
                findsOneWidget,
                reason: 'Should see stop button',
              );
            },
            expectedEvents: [
              RecordAudioEvent_Resume,
            ],
          );

          await tester.screenshot(
            description: 'tap stop',
            arrangeBeforeActions: (arrange) {
              when(arrange.mocks.recordAudioEffect.stop)
                  .thenAnswer((invocation) async {
                return '';
              });

              registerFallbackValue(Uint8List.fromList([]));
              when(
                () => arrange.mocks.recordAudioEffect
                    .getFileBytes(recordingPath: any(named: 'recordingPath')),
              ).thenAnswer(
                (invocation) async {
                  return Uint8List.fromList(
                    // just over 4kb limit
                    List.generate(4097, (index) => index),
                  );
                },
              );
              when(
                () => arrange.mocks.audioRepository.recordingSave(
                  recordingName: any(named: 'recordingName'),
                  recordingBytes: any(named: 'recordingBytes'),
                ),
              ).thenThrow(Exception('BOOM'));
            },
            actions: (actions) async {
              await actions.userAction.tap(find.byKey(const Key('StopButton')));
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('RecordButton')),
                findsOneWidget,
                reason: 'Should see record button',
              );
              expectations.expect(
                find.text('Uh oh, something went wrong.'),
                findsOneWidget,
                reason: 'Should see error snackbar',
              );
            },
            expectedEvents: [
              RecordAudioEvent_Stop,
              RecordAudioEvent_Save,
              '''WARNING: [record_audio_bloc] recording was not saved''',
              RecordAudioEvent_Error,
            ],
          );
        },
      );

      flowTest(
        'recording was effectively empty',
        config: createFlowConfig(
          hasAccessToken: true,
        ),
        descriptions: [
          ...baseDescriptions,
          FTDescription(
            descriptionType: 'AC',
            shortDescription: 'success',
            description: '''Is successful''',
          ),
        ],
        test: (tester) async {
          await tester.setUp(
            arrangeBeforePumpApp: (arrange) async {
              await arrangeBeforeWarpToHome(arrange);
            },
          );

          await tester.screenshot(
            description: 'initial state',
            actions: (actions) async {
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {},
            expectedEvents: [
              'INFO: [router] deeplink: /',
              'Page: Home',
              RecordingsEvent_GetMyRecordings,
            ],
          );

          await tester.screenshot(
            description: 'tap record',
            arrangeBeforeActions: (arrange) {
              when(
                () => arrange.mocks.recordAudioEffect.start(),
              ).thenAnswer((invocation) async {});
            },
            actions: (actions) async {
              await actions.userAction
                  .tap(find.byKey(const Key('RecordButton')));
              await actions.testerAction.pump();
              await actions.testerAction
                  .pump(const Duration(milliseconds: 500));
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('LoadingButton')),
                findsOneWidget,
                reason: 'Should see loading button',
              );
            },
            expectedEvents: [
              RecordAudioEvent_Record,
            ],
          );

          await tester.screenshot(
            description: 'recording started',
            arrangeBeforeActions: (arrange) {
              arrange.mocks.recordAudioEffect.streamController
                  ?.add(RecordState.record);
            },
            actions: (actions) async {
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('PauseButton')),
                findsOneWidget,
                reason: 'Should see pause button',
              );
              expectations.expect(
                find.byKey(const Key('StopButton')),
                findsOneWidget,
                reason: 'Should see stop button',
              );
            },
            expectedEvents: [],
          );

          await tester.screenshot(
            description: 'tap pause button',
            arrangeBeforeActions: (arrange) {
              when(arrange.mocks.recordAudioEffect.pause)
                  .thenAnswer((invocation) async {
                arrange.mocks.recordAudioEffect.streamController
                    ?.add(RecordState.pause);
              });
            },
            actions: (actions) async {
              await actions.userAction
                  .tap(find.byKey(const Key('PauseButton')));
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('ResumeButton')),
                findsOneWidget,
                reason: 'Should see resume button',
              );
            },
            expectedEvents: [
              RecordAudioEvent_Pause,
            ],
          );

          await tester.screenshot(
            description: 'tap resume',
            arrangeBeforeActions: (arrange) {
              when(arrange.mocks.recordAudioEffect.resume)
                  .thenAnswer((invocation) async {
                arrange.mocks.recordAudioEffect.streamController
                    ?.add(RecordState.record);
              });
            },
            actions: (actions) async {
              await actions.userAction
                  .tap(find.byKey(const Key('ResumeButton')));
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('PauseButton')),
                findsOneWidget,
                reason: 'Should see pause button',
              );
              expectations.expect(
                find.byKey(const Key('StopButton')),
                findsOneWidget,
                reason: 'Should see stop button',
              );
            },
            expectedEvents: [
              RecordAudioEvent_Resume,
            ],
          );

          await tester.screenshot(
            description: 'tap stop',
            arrangeBeforeActions: (arrange) {
              when(arrange.mocks.recordAudioEffect.stop)
                  .thenAnswer((invocation) async {
                arrange.mocks.recordAudioEffect.streamController
                    ?.add(RecordState.stop);
                return '';
              });

              when(
                () => arrange.mocks.nowEffect
                    .now(debugLabel: 'RecordAudioEvent_Save'),
              ).thenAnswer(
                (invocation) => DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
              );

              when(
                () => arrange.mocks.authRepository.getUserId(),
              ).thenAnswer((invocation) async => 'fakeUserId');

              registerFallbackValue(Uint8List.fromList([]));
              when(
                () => arrange.mocks.recordAudioEffect
                    .getFileBytes(recordingPath: any(named: 'recordingPath')),
              ).thenAnswer(
                (invocation) async {
                  return Uint8List.fromList(
                    // just at 4kb limit (effectively empty)
                    List.generate(4096, (index) => index),
                  );
                },
              );
              when(
                () => arrange.mocks.audioRepository.recordingSave(
                  recordingName: any(named: 'recordingName'),
                  recordingBytes: any(named: 'recordingBytes'),
                ),
              ).thenAnswer((invocation) async {});
            },
            actions: (actions) async {
              await actions.userAction.tap(find.byKey(const Key('StopButton')));
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.byKey(const Key('RecordButton')),
                findsOneWidget,
                reason: 'Should see record button',
              );
            },
            expectedEvents: [
              RecordAudioEvent_Stop,
              RecordAudioEvent_Save,
              'WARNING: [record_audio_bloc] recording was not saved',
              RecordAudioEvent_Error,
            ],
          );
        },
      );
    });
  });
}
