import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/domain/repositories/location_repository.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/locations/location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final LocationRepository locationRepository;

  LocationCubit({required this.locationRepository}) : super(LocationInitial());

  Future<void> fetchLocations() async {
    emit(LocationLoading());
    final result = await locationRepository.getLocations();

    result.fold(
      (error) => emit(LocationError(error)),
      (locations) => emit(LocationLoaded(locations)),
    );
  }
}
