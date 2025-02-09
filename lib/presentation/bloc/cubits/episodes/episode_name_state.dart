
import 'package:equatable/equatable.dart';

abstract class EpisodeNameState extends Equatable {
  @override
  List<Object> get props => [];
}

class EpisodeNameInitial extends EpisodeNameState {}

class EpisodeNameLoading extends EpisodeNameState {}

class EpisodeLoadedName extends EpisodeNameState {
  final List<String> episodeNames;

  EpisodeLoadedName({required this.episodeNames});
}


class EpisodeNameError extends EpisodeNameState {
  final String message;
  EpisodeNameError(this.message);
}
