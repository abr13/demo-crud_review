import 'package:equatable/equatable.dart';

abstract class BusinessDetailEvent extends Equatable {
  const BusinessDetailEvent();

  @override
  List<Object?> get props => [];
}

class BusinessDetailRequested extends BusinessDetailEvent {
  final String placeId;

  const BusinessDetailRequested({required this.placeId});

  @override
  List<Object?> get props => [placeId];
}

class BusinessDetailRefreshed extends BusinessDetailEvent {
  final String placeId;

  const BusinessDetailRefreshed({required this.placeId});

  @override
  List<Object?> get props => [placeId];
}


