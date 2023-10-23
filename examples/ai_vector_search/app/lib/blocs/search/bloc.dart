import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/search/repository.dart';
import '../base_blocs.dart';
import 'event.dart';
import 'state.dart';

class SearchBloc extends SearchBaseBloc {
  SearchBloc({
    required SearchRepository searchRepository,
  })  : _searchRepository = searchRepository,
        super(
          const SearchState(
            status: SearchStatus.idle,
            markdownResponse: null,
          ),
        ) {
    on<SearchEvent_VectorSearch>(
      _onVectorSearch,
      transformer: sequential(),
    );
  }

  final SearchRepository _searchRepository;

  Future<void> _onVectorSearch(
    SearchEvent_VectorSearch event,
    Emitter<SearchState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SearchStatus.loading,
        clearMarkdownResponse: true,
      ),
    );

    try {
      final markdownResponse = await _searchRepository.vectorSearch(
        query: event.query,
      );
      emit(
        state.copyWith(
          markdownResponse: markdownResponse,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SearchStatus.error,
        ),
      );
    } finally {
      emit(
        state.copyWith(
          status: SearchStatus.idle,
        ),
      );
    }
  }
}
