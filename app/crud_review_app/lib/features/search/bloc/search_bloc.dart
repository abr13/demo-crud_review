import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/repository/api_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ApiRepository _apiRepository;

  SearchBloc({required ApiRepository apiRepository})
    : _apiRepository = apiRepository,
      super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchCleared>(_onSearchCleared);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    try {
      final results = await _apiRepository.search(
        query: event.query.trim(),
        lat: event.lat,
        lng: event.lng,
      );
      emit(SearchSuccess(results: results));
    } catch (e) {
      emit(SearchError(message: e.toString()));
    }
  }

  void _onSearchCleared(SearchCleared event, Emitter<SearchState> emit) {
    emit(SearchInitial());
  }
}
