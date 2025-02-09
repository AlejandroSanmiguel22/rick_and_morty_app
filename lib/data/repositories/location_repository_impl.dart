import 'package:dartz/dartz.dart';
import 'package:rick_and_morty/data/datasources/remote/location_remote_datasource.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;

  LocationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<LocationEntity>>> getLocations() async {
    try {
      final locations = await remoteDataSource.getLocations();
      return Right(locations);
    } catch (e) {
      return Left('Error al obtener ubicaciones');
    }
  }
}
