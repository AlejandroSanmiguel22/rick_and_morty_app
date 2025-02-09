import 'package:dartz/dartz.dart';
import '../entities/character_entity.dart';

abstract class ResidentRepository {
  Future<Either<String, CharacterEntity>> getResident(String url);
}
