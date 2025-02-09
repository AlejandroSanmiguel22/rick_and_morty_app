import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_and_morty/domain/entities/character_entity.dart';
import '../../../../domain/repositories/character_repository.dart';
part 'search_characters_state.dart';

class SearchCharactersCubit extends Cubit<SearchCharactersState> {
  final CharacterRepository repository;

  SearchCharactersCubit(this.repository) : super(SearchCharactersInitial());

  Future<void> suggestCharacters(String query) async {
    if (query.isEmpty) {
      emit(SearchCharactersInitial());
      return;
    }

    emit(SearchCharactersLoading());

    try {
      final suggestions = await repository.suggestCharacters(query);
      emit(SearchCharactersSuggested(suggestions));
    } catch (e) {
      emit(SearchCharactersError(e.toString()));
    }
  }

  Future<void> searchCharacters(String query,
      {String? status, String? gender}) async {
    emit(SearchCharactersLoading());
    try {
      final characters =
          await repository.searchCharacters(query, status, gender);
      if (characters.isEmpty) {
        emit(SearchCharactersEmpty());
      } else {
        emit(SearchCharactersLoaded(characters));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        emit(SearchCharactersEmpty());
      } else {
        emit(SearchCharactersError(e.toString()));
      }
    }
  }
}
