import 'package:dartz/dartz.dart';
import 'package:rick_and_morty/domain/entities/episode_entity.dart';
import '../../domain/repositories/episode_repository.dart';
import '../datasources/remote/episode_remote_datasource.dart';

class EpisodeRepositoryImpl implements EpisodeRepository {
  final EpisodeRemoteDataSource remoteDataSource;

  EpisodeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<EpisodeEntity>>> getEpisodes() async {
    try {
      final episodes = await remoteDataSource.getEpisodes();
      return Right(episodes);
    } catch (e) {
      return Left("Error fetching episodes");
    }
  }

  @override
  Future<Either<String, List<String>>> getEpisodeNames(
      List<String> episodeUrls) async {
    try {
      final episodes = await remoteDataSource.getEpisodeNames(episodeUrls);
      return Right(episodes);
    } catch (e) {
      return Left('Error al obtener episodios');
    }
  }

  @override
  Future<Either<String, List<EpisodeEntity>>> searchEpisodes(
      String episode) async {
    try {
      final episodes = await remoteDataSource.searchEpisodes(episode);
      return Right(episodes);
    } catch (e) {
      return Left('Error al buscar episodios');
    }
  }

  @override
  Future<List<EpisodeEntity>> suggestEpisodes(String query) async {
    return await remoteDataSource.suggestEpisodes(query);
  }
}
