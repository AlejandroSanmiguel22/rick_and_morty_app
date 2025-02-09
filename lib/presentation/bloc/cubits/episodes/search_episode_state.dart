
import 'package:equatable/equatable.dart';
import 'package:rick_and_morty/domain/entities/episode_entity.dart';

abstract class SearchEpisodeState extends Equatable {
  const SearchEpisodeState();

  @override
  List<Object> get props => [];
}

class SearchEpisodeInitial extends SearchEpisodeState {}

class SearchEpisodeLoading extends SearchEpisodeState {}

class SearchEpisodeLoaded extends SearchEpisodeState {
  final List<EpisodeEntity> episodes;

  const SearchEpisodeLoaded(this.episodes);

  @override
  List<Object> get props => [episodes];
}

class SearchEpisodeError extends SearchEpisodeState {
  final String message;

  const SearchEpisodeError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchEpisodeSuggested extends SearchEpisodeState {
  final List<EpisodeEntity> suggestions;

  const SearchEpisodeSuggested(this.suggestions);

  @override
  List<Object> get props => [suggestions];
}