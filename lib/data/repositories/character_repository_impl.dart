import 'package:dartz/dartz.dart';
import '../../domain/entities/character_entity.dart';
import '../../domain/repositories/character_repository.dart';
import '../datasources/remote/character_remote_datasource.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;

  CharacterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<CharacterEntity>>> getCharacters() async {
    try {
      final characters = await remoteDataSource.getCharacters();

      // Mapeamos CharacterModel a CharacterEntity
      final characterEntities = characters.map<CharacterEntity>((character) {
        return CharacterEntity(
          id: character.id,
          name: character.name,
          status: character.status,
          species: character.species,
          type: character.type,
          gender: character.gender,
          image: character.image,
          episode: character.episode,
          origin: character.origin.name,
          location: character.location.name,
        );
      }).toList();

      return Right(characterEntities);
    } catch (e) {
      return Left('Error obteniendo personajes: $e');
    }
  }
}
