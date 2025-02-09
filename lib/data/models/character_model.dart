import 'package:rick_and_morty/domain/entities/character_entity.dart';


class CharacterModel extends CharacterEntity {
  CharacterModel({
    required int id,
    required String name,
    required String status,
    required String species,
    required String type,
    required String gender,
    required String image,
    required List<String> episode,
    required String origin,
    required String location,
  }) : super(
          id: id,
          name: name,
          status: status,
          species: species,
          type: type,
          gender: gender,
          image: image,
          episode: episode,
          origin: origin,
          location: location,
        );

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] ?? 0, 
      name: json['name'] ?? "Desconocido",
      status: json['status'] ?? "Desconocido",
      species: json['species'] ?? "Desconocido",
      type: json['type'] ?? "",
      gender: json['gender'] ?? "Desconocido",
      image: json['image'] ?? "https://via.placeholder.com/150",
      episode: (json['episode'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      origin: json['origin']?['name'] ?? "Desconocido",
      location: json['location']?['name'] ?? "Desconocido",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'image': image,
      'episode': episode,
      'origin': origin,
      'location': location,
    };
  }
}
