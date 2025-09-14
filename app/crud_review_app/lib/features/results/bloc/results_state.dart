import 'package:equatable/equatable.dart';
import '../models/business.dart';

abstract class ResultsState extends Equatable {
  const ResultsState();

  @override
  List<Object?> get props => [];
}

class ResultsInitial extends ResultsState {}

class ResultsLoading extends ResultsState {}

class ResultsSuccess extends ResultsState {
  final List<Business> results;
  final List<Business> originalResults;
  final String? ratingFilter;
  final String? distanceFilter;
  final String? categoryFilter;

  const ResultsSuccess({
    required this.results,
    required this.originalResults,
    this.ratingFilter,
    this.distanceFilter,
    this.categoryFilter,
  });

  @override
  List<Object?> get props => [
    results,
    originalResults,
    ratingFilter,
    distanceFilter,
    categoryFilter,
  ];
}

class ResultsError extends ResultsState {
  final String message;

  const ResultsError({required this.message});

  @override
  List<Object?> get props => [message];
}
