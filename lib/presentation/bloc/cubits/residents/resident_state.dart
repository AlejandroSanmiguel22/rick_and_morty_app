import 'package:rick_and_morty/domain/entities/character_entity.dart';

class ResidentState {}

class ResidentInitial extends ResidentState {}

class ResidentLoading extends ResidentState {}

class ResidentLoaded extends ResidentState {
  final CharacterEntity resident;
  ResidentLoaded(this.resident);
}

class ResidentError extends ResidentState {
  final String message;
  ResidentError(this.message);
}