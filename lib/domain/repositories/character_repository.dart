import 'package:dartz/dartz.dart';
import '../entities/character_entity.dart';

abstract class CharacterRepository {
  Future<Either<String, List<CharacterEntity>>> getCharacters();
   Future<List<CharacterEntity>> searchCharacters(String query);
}
