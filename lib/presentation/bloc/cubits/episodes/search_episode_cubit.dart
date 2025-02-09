import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:rick_and_morty/domain/entities/episode_entity.dart';
import 'package:rick_and_morty/domain/repositories/episode_repository.dart';
import 'package:rick_and_morty/presentation/bloc/cubits/episodes/search_episode_state.dart';

class SearchEpisodeCubit extends Cubit<SearchEpisodeState> {
  final EpisodeRepository episodeRepository;

  SearchEpisodeCubit(this.episodeRepository) : super(SearchEpisodeInitial());

  Future<void> searchEpisodes({String? name, List<String>? episodes}) async {
    emit(SearchEpisodeLoading());

    final Either<String, List<EpisodeEntity>> result =
        await episodeRepository.searchEpisodes(name: name, episodes: episodes);

    result.fold(
      (error) => emit(SearchEpisodeError(error)),
      (episodes) => emit(SearchEpisodeLoaded(episodes)),
    );
  }

  Future<void> suggestEpisodes(String query) async {
    if (query.isEmpty) {
      emit(SearchEpisodeInitial());
      return;
    }
    emit(SearchEpisodeLoading());
    try {
      final suggestions = await episodeRepository.suggestEpisodes(query);
      emit(SearchEpisodeSuggested(
          suggestions)); // Asegúrate de que se emite el estado correcto
    } catch (e) {
      emit(SearchEpisodeError(e.toString()));
    }
  }
}
