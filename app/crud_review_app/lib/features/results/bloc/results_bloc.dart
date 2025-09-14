import 'package:flutter_bloc/flutter_bloc.dart';
import 'results_event.dart';
import 'results_state.dart';
import '../models/business.dart';

class ResultsBloc extends Bloc<ResultsEvent, ResultsState> {
  ResultsBloc() : super(ResultsInitial()) {
    on<ResultsLoaded>(_onResultsLoaded);
    on<ResultsRefreshed>(_onResultsRefreshed);
    on<ResultsFiltered>(_onResultsFiltered);
    on<ResultsFilterCleared>(_onResultsFilterCleared);
    on<ResultsUpdated>(_onResultsUpdated);
  }

  void _onResultsLoaded(ResultsLoaded event, Emitter<ResultsState> emit) {
    emit(
      ResultsSuccess(results: event.results, originalResults: event.results),
    );
  }

  Future<void> _onResultsRefreshed(
    ResultsRefreshed event,
    Emitter<ResultsState> emit,
  ) async {
    if (state is ResultsSuccess) {
      // Just refresh the current state without API call
      final currentState = state as ResultsSuccess;
      emit(
        ResultsSuccess(
          results: currentState.originalResults,
          originalResults: currentState.originalResults,
          ratingFilter: currentState.ratingFilter,
          distanceFilter: currentState.distanceFilter,
          categoryFilter: currentState.categoryFilter,
        ),
      );
    }
  }

  void _onResultsFiltered(ResultsFiltered event, Emitter<ResultsState> emit) {
    if (state is ResultsSuccess) {
      final currentState = state as ResultsSuccess;
      List<Business> filteredResults = List.from(currentState.originalResults);

      // Apply rating filter
      if (event.ratingFilter != null) {
        final minRating = _getMinRatingFromFilter(event.ratingFilter!);
        if (minRating != null) {
          filteredResults = filteredResults
              .where((business) => business.rating >= minRating)
              .toList();
        }
      }

      // Apply distance filter
      if (event.distanceFilter != null) {
        final maxDistance = _getMaxDistanceFromFilter(event.distanceFilter!);
        if (maxDistance != null) {
          filteredResults = filteredResults
              .where((business) => business.distanceMeters <= maxDistance)
              .toList();
        }
      }

      // Apply category filter
      if (event.categoryFilter != null) {
        filteredResults = filteredResults
            .where(
              (business) => business.category.toLowerCase().contains(
                event.categoryFilter!.toLowerCase(),
              ),
            )
            .toList();
      }

      emit(
        ResultsSuccess(
          results: filteredResults,
          originalResults: currentState.originalResults,
          ratingFilter: event.ratingFilter,
          distanceFilter: event.distanceFilter,
          categoryFilter: event.categoryFilter,
        ),
      );
    }
  }

  void _onResultsFilterCleared(
    ResultsFilterCleared event,
    Emitter<ResultsState> emit,
  ) {
    if (state is ResultsSuccess) {
      final currentState = state as ResultsSuccess;
      emit(
        ResultsSuccess(
          results: currentState.originalResults,
          originalResults: currentState.originalResults,
        ),
      );
    }
  }

  void _onResultsUpdated(ResultsUpdated event, Emitter<ResultsState> emit) {
    if (state is ResultsSuccess) {
      final currentState = state as ResultsSuccess;
      // Update original results and reapply current filters
      List<Business> filteredResults = List.from(event.newResults);

      // Apply current filters to new results
      if (currentState.ratingFilter != null) {
        final minRating = _getMinRatingFromFilter(currentState.ratingFilter!);
        if (minRating != null) {
          filteredResults = filteredResults
              .where((business) => business.rating >= minRating)
              .toList();
        }
      }

      if (currentState.distanceFilter != null) {
        final maxDistance = _getMaxDistanceFromFilter(
          currentState.distanceFilter!,
        );
        if (maxDistance != null) {
          filteredResults = filteredResults
              .where((business) => business.distanceMeters <= maxDistance)
              .toList();
        }
      }

      if (currentState.categoryFilter != null) {
        filteredResults = filteredResults
            .where(
              (business) => business.category.toLowerCase().contains(
                currentState.categoryFilter!.toLowerCase(),
              ),
            )
            .toList();
      }

      emit(
        ResultsSuccess(
          results: filteredResults,
          originalResults: event.newResults,
          ratingFilter: currentState.ratingFilter,
          distanceFilter: currentState.distanceFilter,
          categoryFilter: currentState.categoryFilter,
        ),
      );
    } else {
      // No current state, just emit new results
      emit(
        ResultsSuccess(
          results: event.newResults,
          originalResults: event.newResults,
        ),
      );
    }
  }

  double? _getMinRatingFromFilter(String filter) {
    switch (filter) {
      case '4.5+ Stars':
        return 4.5;
      case '4.0+ Stars':
        return 4.0;
      case '3.5+ Stars':
        return 3.5;
      case '3.0+ Stars':
        return 3.0;
      default:
        return null;
    }
  }

  int? _getMaxDistanceFromFilter(String filter) {
    switch (filter) {
      case 'Within 500m':
        return 500;
      case 'Within 1km':
        return 1000;
      case 'Within 2km':
        return 2000;
      case 'Within 5km':
        return 5000;
      default:
        return null;
    }
  }
}
