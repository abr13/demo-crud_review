import 'package:equatable/equatable.dart';
import '../models/business.dart';

abstract class ResultsEvent extends Equatable {
  const ResultsEvent();

  @override
  List<Object?> get props => [];
}

class ResultsLoaded extends ResultsEvent {
  final List<Business> results;
  final String? query;
  final double? lat;
  final double? lng;

  const ResultsLoaded({required this.results, this.query, this.lat, this.lng});

  @override
  List<Object?> get props => [results, query, lat, lng];
}

class ResultsRefreshed extends ResultsEvent {
  const ResultsRefreshed();
}

class ResultsFiltered extends ResultsEvent {
  final String? ratingFilter;
  final String? distanceFilter;
  final String? categoryFilter;

  const ResultsFiltered({
    this.ratingFilter,
    this.distanceFilter,
    this.categoryFilter,
  });

  @override
  List<Object?> get props => [ratingFilter, distanceFilter, categoryFilter];
}

class ResultsFilterCleared extends ResultsEvent {
  const ResultsFilterCleared();
}

class ResultsUpdated extends ResultsEvent {
  final List<Business> newResults;

  const ResultsUpdated({required this.newResults});

  @override
  List<Object?> get props => [newResults];
}
