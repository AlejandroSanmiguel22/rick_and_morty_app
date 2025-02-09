import '../../domain/entities/episode_entity.dart';

class EpisodeModel extends EpisodeEntity {
  EpisodeModel({
    required super.id,
    required super.name,
    required super.airDate,
    required super.episode,
    required super.characters,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "Unknown",
      airDate: json['air_date'] ?? "Unknown",
      episode: json['episode'] ?? "Unknown",
      characters: List<String>.from(json['characters'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'air_date': airDate,
      'episode': episode,
      'characters': characters,
    };
  }
}
