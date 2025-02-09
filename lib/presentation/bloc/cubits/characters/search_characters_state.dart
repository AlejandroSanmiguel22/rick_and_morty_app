part of 'search_characters_cubit.dart';

abstract class SearchCharactersState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchCharactersInitial extends SearchCharactersState {}

class SearchCharactersLoading extends SearchCharactersState {}

class SearchCharactersLoaded extends SearchCharactersState {
  final List<CharacterEntity> characters;

  SearchCharactersLoaded(this.characters);

  @override
  List<Object?> get props => [characters];
}

class SearchCharactersEmpty extends SearchCharactersState {}

class SearchCharactersError extends SearchCharactersState {
  final String message;

  SearchCharactersError(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchCharactersSuggested extends SearchCharactersState {
  final List<CharacterEntity> suggestions;

  SearchCharactersSuggested(this.suggestions);

  @override
  List<Object?> get props => [suggestions];
}

