import 'package:dio/dio.dart';

class EpisodeRemoteDataSource {
  final Dio dio;

  EpisodeRemoteDataSource(this.dio);

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
