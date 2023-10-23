import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/chat/repository.dart';
import '../base_blocs.dart';
import 'event.dart';
import 'state.dart';

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

  StreamSubscription<List<Map<String, dynamic>>>? _subscription;

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    _subscription = null;
    await super.close();
  }

  Future<void> _onInitialize(
    ChatEvent_Initialize event,
    Emitter<ChatState> emit,
  ) async {
    final stream = await _chatRepository.getMessagesStream();
    _subscription = stream.listen(
      (rows) {
        final updatedMessages =
            rows.map((row) => row['message'] as String).toList();

        add(ChatEvent_UpdateMessages(messages: updatedMessages));
      },
      onDone: () async {
        _subscription = null;
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
