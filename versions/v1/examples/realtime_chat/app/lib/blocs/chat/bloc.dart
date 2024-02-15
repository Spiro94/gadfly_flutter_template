import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/chat/repository.dart';
import '../base_blocs.dart';
import 'event.dart';
import 'state.dart';

// Reference: https://github.com/flutter/flutter/issues/69949
//
// There is a nasty bug in Flutter Web during development where `dispose` is NOT
// called on hot-restart. This has implications for us because we want to listen
// to a stream. When we hot-restart, our current stream will not be canceled and
// yet we listen to a new stream. So there is a leak with our original stream.
//
// If we store our [_subscription] in a static variable, then on hot-restart it
// will get replaced. We can then check if [_subscription] is null in our
// listener, and if it is, we can simply not handle the events. So during
// development, we are allowing multiple listeners to acrue, but only the most
// recent will handle events. Note: this problem does not exist in production
// and it does not exist in mobile (only development time on web).
//
// To make this work, look for HR1 and HR2.

class ChatBloc extends ChatBaseBloc {
  ChatBloc({
    required ChatRepository chatRepository,
  })  : _chatRepository = chatRepository,
        super(
          const ChatState(
            status: ChatStatus.idle,
            messages: [],
          ),
        ) {
    on<ChatEvent_Initialize>(
      _onInitialize,
      transformer: sequential(),
    );

    on<ChatEvent_UpdateMessages>(
      _onUpdateMessages,
      transformer: sequential(),
    );

    on<ChatEvent_SendMessage>(
      _onSendMessage,
      transformer: sequential(),
    );
  }

  final ChatRepository _chatRepository;

  // ATTENTION: HR1
  static StreamSubscription<List<Map<String, dynamic>>>? _subscription;
  // ---

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await super.close();
  }

  Future<void> _onInitialize(
    ChatEvent_Initialize event,
    Emitter<ChatState> emit,
  ) async {
    final stream = await _chatRepository.getMessagesStream();
    _subscription = stream.listen(
      (rows) {
        // ATTENTION: HR2
        if (_subscription == null) return;
        // --

        final updatedMessages =
            rows.map((row) => row['message'] as String).toList();

        add(ChatEvent_UpdateMessages(messages: updatedMessages));
      },
    );
  }

  Future<void> _onUpdateMessages(
    ChatEvent_UpdateMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(
      state.copyWith(messages: event.messages),
    );
  }

  Future<void> _onSendMessage(
    ChatEvent_SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    emit(
      state.copyWith(status: ChatStatus.loading),
    );

    try {
      final message = event.message.trim();

      await _chatRepository.sendMessage(
        message: message,
      );
    } catch (e) {
      emit(
        state.copyWith(status: ChatStatus.error),
      );
    } finally {
      emit(
        state.copyWith(status: ChatStatus.idle),
      );
    }
  }
}
