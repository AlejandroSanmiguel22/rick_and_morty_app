import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../domain/entities/character_entity.dart';
import '../../../domain/repositories/character_repository.dart';
import 'character_state.dart';

class CharacterCubit extends Cubit<CharacterState> {
  final CharacterRepository repository;

  CharacterCubit({required this.repository}) : super(CharacterInitial());

  Future<void> fetchCharacters() async {
    emit(CharacterLoading());
    final Either<String, List<CharacterEntity>> result = await repository.getCharacters();
    
    result.fold(
      (error) => emit(CharacterError(error)),
      (characters) => emit(CharacterLoaded(characters)),
    );
  }
}
