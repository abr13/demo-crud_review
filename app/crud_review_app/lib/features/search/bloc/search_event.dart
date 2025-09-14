import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;
  final double lat;
  final double lng;

  const SearchQueryChanged({
    required this.query,
    required this.lat,
    required this.lng,
  });

  @override
  List<Object?> get props => [query, lat, lng];
}

class SearchCleared extends SearchEvent {
  const SearchCleared();
}


