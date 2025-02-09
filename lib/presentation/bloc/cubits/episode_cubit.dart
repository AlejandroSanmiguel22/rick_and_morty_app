import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../domain/repositories/episode_repository.dart';

abstract class EpisodeState {}

class EpisodeInitial extends EpisodeState {}

class EpisodeLoading extends EpisodeState {}

class EpisodeLoaded extends EpisodeState {
  final List<String> episodeNames;
  EpisodeLoaded(this.episodeNames);
}

class EpisodeError extends EpisodeState {
  final String message;
  EpisodeError(this.message);
}

class EpisodeCubit extends Cubit<EpisodeState> {
  final EpisodeRepository episodeRepository;

  EpisodeCubit({required this.episodeRepository}) : super(EpisodeInitial());

  Future<void> fetchEpisodes(List<String> episodeUrls) async {
    emit(EpisodeLoading());

    final Either<String, List<String>> result = await episodeRepository.getEpisodeNames(episodeUrls);

    result.fold(
      (error) => emit(EpisodeError(error)),
      (episodes) => emit(EpisodeLoaded(episodes)),
    );
  }
}