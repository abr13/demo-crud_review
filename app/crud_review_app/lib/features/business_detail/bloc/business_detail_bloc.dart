import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/repository/api_repository.dart';
import 'business_detail_event.dart';
import 'business_detail_state.dart';

class BusinessDetailBloc
    extends Bloc<BusinessDetailEvent, BusinessDetailState> {
  final ApiRepository _apiRepository;

  BusinessDetailBloc({required ApiRepository apiRepository})
    : _apiRepository = apiRepository,
      super(BusinessDetailInitial()) {
    on<BusinessDetailRequested>(_onBusinessDetailRequested);
    on<BusinessDetailRefreshed>(_onBusinessDetailRefreshed);
  }

  Future<void> _onBusinessDetailRequested(
    BusinessDetailRequested event,
    Emitter<BusinessDetailState> emit,
  ) async {
    emit(BusinessDetailLoading());

    try {
      final businessDetail = await _apiRepository.getPlaceDetails(
        event.placeId,
      );
      emit(BusinessDetailSuccess(businessDetail: businessDetail));
    } catch (e) {
      emit(BusinessDetailError(message: e.toString()));
    }
  }

  Future<void> _onBusinessDetailRefreshed(
    BusinessDetailRefreshed event,
    Emitter<BusinessDetailState> emit,
  ) async {
    try {
      final businessDetail = await _apiRepository.getPlaceDetails(
        event.placeId,
      );
      emit(BusinessDetailSuccess(businessDetail: businessDetail));
    } catch (e) {
      emit(BusinessDetailError(message: e.toString()));
    }
  }
}
