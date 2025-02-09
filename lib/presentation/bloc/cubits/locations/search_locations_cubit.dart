import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_and_morty/domain/entities/location_entity.dart';
import 'package:rick_and_morty/domain/repositories/location_repository.dart';

part 'search_locations_state.dart';

class SearchLocationsCubit extends Cubit<SearchLocationsState> {
  final LocationRepository repository;

  SearchLocationsCubit(this.repository) : super(SearchLocationsInitial());

  Future<void> suggestLocations(String query) async {
    if (query.isEmpty) {
      emit(SearchLocationsInitial());
      return;
    }

    emit(SearchLocationsLoading());

    try {
      final suggestions = await repository.suggestLocations(query);
      emit(SearchLocationsSuggested(suggestions));
    } catch (e) {
      emit(SearchLocationsError(e.toString()));
    }
  }

  Future<void> searchLocations(String query,
      {String? type, String? dimension}) async {
    emit(SearchLocationsLoading());
    try {
      final locations = await repository.searchLocations(query,
          type: type, dimension: dimension);
      if (locations.isEmpty) {
        emit(SearchLocationsEmpty());
      } else {
        emit(SearchLocationsLoaded(locations));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        emit(SearchLocationsEmpty());
      } else {
        emit(SearchLocationsError(e.toString()));
      }
    }
  }
}
