import 'package:dartz/dartz.dart';
import 'package:rick_and_morty/data/models/character_model.dart';
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
  Future<List<CharacterEntity>> searchCharacters(String query) async {
    final results = await remoteDataSource.searchCharacters(query);
    return results.map((json) => CharacterModel.fromJson(json)).toList();
  }
}
