import 'package:dartz/dartz.dart';
import '../entities/location_entity.dart';

abstract class LocationRepository {
  Future<Either<String, List<LocationEntity>>> getLocations();
  Future<List<LocationEntity>> suggestLocations(String query);
  Future<List<LocationEntity>> searchLocations(String query, {String? type, String? dimension});
}
