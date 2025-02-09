import 'package:dartz/dartz.dart';
import '../../domain/entities/character_entity.dart';
import '../../domain/repositories/resident_repository.dart';
import '../datasources/remote/resident_remote_datasource.dart';

class ResidentRepositoryImpl implements ResidentRepository {
  final ResidentRemoteDataSource remoteDataSource;

  ResidentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, CharacterEntity>> getResident(String url) async {
    try {
      final resident = await remoteDataSource.getResident(url);
      return Right(resident);
    } catch (e) {
      return Left("Error al obtener residente");
    }
  }
}
