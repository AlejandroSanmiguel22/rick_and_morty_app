import 'package:rick_and_morty/domain/entities/character_entity.dart';

abstract class ResidentState {}

class ResidentInitial extends ResidentState {}

class ResidentLoading extends ResidentState {}

class ResidentLoaded extends ResidentState {
  final CharacterEntity resident;
  ResidentLoaded(this.resident);
}

class ResidentsLoaded extends ResidentState {
  final List<CharacterEntity> residents;
  ResidentsLoaded(this.residents);
}

class ResidentError extends ResidentState {
  final String message;
  ResidentError(this.message);
}