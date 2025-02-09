import 'package:dio/dio.dart';
import 'package:rick_and_morty/core/network/api_client.dart';
import 'package:rick_and_morty/data/models/episode_model.dart';

class EpisodeRemoteDataSource {
  final ApiClient apiClient;

  EpisodeRemoteDataSource(this.apiClient);

  Future<List<EpisodeModel>> getEpisodes() async {
    try {
      final response =
          await apiClient.get("https://rickandmortyapi.com/api/episode");
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
        final response = await apiClient.get(url);
        episodeNames.add(response.data['name']);
      }

      return episodeNames;
    } catch (e) {
      return ["Error loading episodes"];
    }
  }

  Future<List<EpisodeModel>> suggestEpisodes(String query) async {
    try {
      final response = await apiClient.dio.get(
        "https://rickandmortyapi.com/api/episode/",
        queryParameters: {"name": query}, // Debe ser "name"
      );
      final List results = response.data['results'];
      return results.map((e) => EpisodeModel.fromJson(e)).toList();
    } catch (e) {
      return []; // Retorna una lista vacía en lugar de lanzar error
    }
  }

  Future<List<EpisodeModel>> searchEpisodes(
      {String? name, List<String>? episodes}) async {
    try {
      final response = await apiClient.dio.get(
        "https://rickandmortyapi.com/api/episode/",
        queryParameters: {
          if (name != null && name.isNotEmpty) "name": name,
          if (episodes != null && episodes.isNotEmpty)
            "episode": episodes.join(','), // Unimos múltiples temporadas
        },
      );
      print(
          "URL llamada: https://rickandmortyapi.com/api/episode/?name=$name&episode=${episodes?.join(',')}");
      final List results = response.data['results'];
      return results.map((e) => EpisodeModel.fromJson(e)).toList();
    } catch (e) {
      print(
          "URL llamada: https://rickandmortyapi.com/api/episode/?name=$name&episode=${episodes?.join(',')}");

      throw Exception('Error searching episodes');
    }
  }
}
