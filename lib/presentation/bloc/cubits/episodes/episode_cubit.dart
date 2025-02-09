import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/episodes/episode_state.dart';
import '../../../../domain/repositories/episode_repository.dart';
class EpisodeCubit extends Cubit<EpisodeState> {
  final EpisodeRepository episodeRepository;

  EpisodeCubit({required this.episodeRepository}) : super(EpisodeInitial());

   Future<void> fetchEpisodes() async {
    emit(EpisodeLoading());
    final result = await episodeRepository.getEpisodes();

    result.fold(
      (error) => emit(EpisodeError(error)),
      (episodes) => emit(EpisodeLoaded(episodes)),
    );
  }
  
}