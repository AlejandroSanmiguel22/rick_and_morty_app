class EpisodeEntity {
  final int id;
  final String name;
  final String airDate;
  final String episode;
  final List<String> characters;

  EpisodeEntity({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episode,
    required this.characters,
  });
}
