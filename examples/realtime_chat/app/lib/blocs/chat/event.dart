sealed class ChatEvent {}

class ChatEvent_Initialize extends ChatEvent {}

class ChatEvent_SendMessage extends ChatEvent {
  ChatEvent_SendMessage({
    required this.message,
  });

  final String message;
}

class ChatEvent_UpdateMessages extends ChatEvent {
  ChatEvent_UpdateMessages({
    required this.messages,
  });

  final List<String> messages;
}
