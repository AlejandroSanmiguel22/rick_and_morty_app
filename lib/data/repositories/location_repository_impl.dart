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

  @override
  Future<List<LocationEntity>> suggestLocations(String query) async {
    return await remoteDataSource.suggestLocations(query);
  }

  @override
  Future<List<LocationEntity>> searchLocations(String query, {String? type, String? dimension}) async {
    final locations = await remoteDataSource.searchLocations(query, type: type, dimension: dimension);
    print(locations);
    return locations;
  }
}
