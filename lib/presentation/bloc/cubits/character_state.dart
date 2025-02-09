import 'package:equatable/equatable.dart';
import '../../../domain/entities/character_entity.dart';

abstract class CharacterState extends Equatable {
  @override
  List<Object> get props => [];
}

class CharacterInitial extends CharacterState {}

class CharacterLoading extends CharacterState {}

class CharacterLoaded extends CharacterState {
  final List<CharacterEntity> characters;

  CharacterLoaded(this.characters);

  @override
  List<Object> get props => [characters];
}

class CharacterError extends CharacterState {
  final String message;

  CharacterError(this.message);

  @override
  List<Object> get props => [message];
}
