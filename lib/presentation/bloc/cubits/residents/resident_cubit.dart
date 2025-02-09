import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/domain/repositories/resident_repository.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/residents/resident_state.dart';

class ResidentCubit extends Cubit<ResidentState> {
  final ResidentRepository residentRepository;

  ResidentCubit({required this.residentRepository}) : super(ResidentInitial());

  Future<void> fetchResident(String url) async {
    emit(ResidentLoading());
    final result = await residentRepository.getResident(url);

    result.fold(
      (error) => emit(ResidentError(error)),
      (resident) => emit(ResidentLoaded(resident)),
    );
  }
}