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
      return Right(characters);
    } catch (e) {
      return Left("Error al obtener personajes: ${e.toString()}");
    }
  }

  @override
  Future<List<CharacterEntity>> suggestCharacters(String query) async {
    return await remoteDataSource.suggestCharacters(query);
  }

  @override
  Future<List<CharacterEntity>> searchCharacters(String query, String? status, String? gender) async {
    final characters = await remoteDataSource.searchCharacters(query,
        status: status, gender: gender);

    print(characters);
    return characters;
  }
}
