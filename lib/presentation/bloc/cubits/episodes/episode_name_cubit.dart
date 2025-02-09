import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/domain/entities/episode_entity.dart';
import 'package:rick_and_morty/domain/repositories/episode_repository.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/episodes/episode_name_state.dart';

class EpisodeNameCubit extends Cubit<EpisodeNameState> {
  final EpisodeRepository episodeRepository;

  EpisodeNameCubit({required this.episodeRepository}) : super(EpisodeNameInitial());

  Future<void> fetchEpisodesName(List<String> episodeUrls) async {
    emit(EpisodeNameLoading());

    final Either<String, List<String>> result = await episodeRepository.getEpisodeNames(episodeUrls);

    result.fold(
      (error) => emit(EpisodeNameError(error)),
      (episodeNames) => emit(EpisodeLoadedName(episodeNames: episodeNames)),
    );
  }


}
