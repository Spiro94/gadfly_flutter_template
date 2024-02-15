import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

enum SearchStatus {
  idle,
  loading,
  error,
}

@JsonSerializable()
class SearchState extends Equatable {
  const SearchState({
    required this.status,
    required this.markdownResponse,
  });

  final SearchStatus status;
  final String? markdownResponse;

  SearchState copyWith({
    SearchStatus? status,
    String? markdownResponse,
    bool clearMarkdownResponse = false,
  }) {
    return SearchState(
      status: status ?? this.status,
      markdownResponse: clearMarkdownResponse
          ? null
          : markdownResponse ?? this.markdownResponse,
    );
  }

  @override
  List<Object?> get props => [
        status,
        markdownResponse,
      ];

  // coverage:ignore-start
  factory SearchState.fromJson(Map<String, dynamic> json) =>
      _$SearchStateFromJson(json);

  Map<String, dynamic> toJson() => _$SearchStateToJson(this);
  // coverage:ignore-end
}
