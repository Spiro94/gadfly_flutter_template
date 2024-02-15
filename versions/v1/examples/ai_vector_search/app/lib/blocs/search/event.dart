sealed class SearchEvent {}

class SearchEvent_VectorSearch extends SearchEvent {
  SearchEvent_VectorSearch({required this.query});

  final String query;
}
