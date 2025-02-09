import 'package:dartz/dartz.dart';
import 'package:rick_and_morty/domain/entities/episode_entity.dart';

abstract class EpisodeRepository {
  Future<Either<String, List<EpisodeEntity>>> getEpisodes();
  Future<Either<String, List<String>>> getEpisodeNames(
      List<String> episodeUrls);

  Future<Either<String, List<EpisodeEntity>>> searchEpisodes(String episode);
  Future<List<EpisodeEntity>> suggestEpisodes(String query);
}
