import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

enum ChatStatus {
  idle,
  loading,
  error,
}

@JsonSerializable()
class ChatState extends Equatable {
  const ChatState({
    required this.status,
    required this.messages,
  });

  final ChatStatus status;
  final List<String> messages;

  ChatState copyWith({
    ChatStatus? status,
    List<String>? messages,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [
        status,
        messages,
      ];

  // coverage:ignore-start
  factory ChatState.fromJson(Map<String, dynamic> json) =>
      _$ChatStateFromJson(json);

  Map<String, dynamic> toJson() => _$ChatStateToJson(this);
  // coverage:ignore-end
}
