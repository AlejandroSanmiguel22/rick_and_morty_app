import 'package:dartz/dartz.dart';
import '../entities/location_entity.dart';

abstract class LocationRepository {
  Future<Either<String, List<LocationEntity>>> getLocations();
}
