import 'package:dartz/dartz.dart';

abstract class EpisodeRepository {
  Future<Either<String, List<String>>> getEpisodeNames(List<String> episodeUrls);
}