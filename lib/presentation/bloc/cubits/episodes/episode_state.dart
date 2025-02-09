import 'package:equatable/equatable.dart';
import 'package:rick_and_morty/domain/entities/episode_entity.dart';

abstract class EpisodeState extends Equatable {
  @override
  List<Object> get props => [];
}

class EpisodeInitial extends EpisodeState {}

class EpisodeLoading extends EpisodeState {}

class EpisodeLoaded extends EpisodeState {
  final List<EpisodeEntity> episodes;

  EpisodeLoaded(this.episodes);
}

class EpisodeError extends EpisodeState {
  final String message;
  EpisodeError(this.message);
}
