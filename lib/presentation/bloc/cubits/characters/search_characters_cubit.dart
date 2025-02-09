import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_and_morty/domain/entities/character_entity.dart';
import '../../../../domain/repositories/character_repository.dart';
part 'search_characters_state.dart';

class SearchCharactersCubit extends Cubit<SearchCharactersState> {
  final CharacterRepository characterRepository;

  SearchCharactersCubit(this.characterRepository)
      : super(SearchCharactersInitial());

  void searchCharacters(String query) async {
    if (query.isEmpty) {
      emit(SearchCharactersInitial());
      return;
    }

    emit(SearchCharactersLoading());

    try {
      final characters = await characterRepository.searchCharacters(query);
      if (characters.isEmpty) {
        emit(SearchCharactersEmpty());
      } else {
        emit(SearchCharactersLoaded(characters));
      }
    } catch (e) {
      emit(SearchCharactersError("Error al buscar personajes"));
    }
  }

  void suggestCharacters(String query) async {
    if (query.isEmpty) {
      emit(SearchCharactersInitial());
      return;
    }

    try {
      final characters = await characterRepository.searchCharacters(query);
      emit(SearchCharactersSuggested(characters));
    } catch (e) {
      emit(SearchCharactersError("Error al buscar sugerencias"));
    }
  }
}
