import 'package:equatable/equatable.dart';
import '../models/business_detail.dart';

abstract class BusinessDetailState extends Equatable {
  const BusinessDetailState();

  @override
  List<Object?> get props => [];
}

class BusinessDetailInitial extends BusinessDetailState {}

class BusinessDetailLoading extends BusinessDetailState {}

class BusinessDetailSuccess extends BusinessDetailState {
  final BusinessDetail businessDetail;

  const BusinessDetailSuccess({required this.businessDetail});

  @override
  List<Object?> get props => [businessDetail];
}

class BusinessDetailError extends BusinessDetailState {
  final String message;

  const BusinessDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}


