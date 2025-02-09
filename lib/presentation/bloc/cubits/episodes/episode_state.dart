import 'package:equatable/equatable.dart';

abstract class EpisodeState extends Equatable {
  @override
  List<Object> get props => [];
}

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
