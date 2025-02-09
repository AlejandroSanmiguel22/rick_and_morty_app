import 'package:dio/dio.dart';
import 'package:rick_and_morty/data/models/episode_model.dart';

class EpisodeRemoteDataSource {
  final Dio dio;

  EpisodeRemoteDataSource(this.dio);

  Future<List<EpisodeModel>> getEpisodes() async {
    try {
      final response = await dio.get("https://rickandmortyapi.com/api/episode");
      final List results = response.data['results'];
      return results.map((e) => EpisodeModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Error fetching episodes: ${e.toString()}");
    }
  }

  Future<List<String>> getEpisodeNames(List<String> episodeUrls) async {
    try {
      List<String> episodeNames = [];

      for (var url in episodeUrls) {
        final response = await dio.get(url);
        episodeNames.add(response.data['name']);
      }

      return episodeNames;
    } catch (e) {
      return ["Error al cargar episodios"];
    }
  }
}
