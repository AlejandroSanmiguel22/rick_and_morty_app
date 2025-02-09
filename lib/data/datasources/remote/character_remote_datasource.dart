import 'package:dio/dio.dart';
import 'package:rick_and_morty/core/network/api_client.dart';
import 'package:rick_and_morty/data/models/character_model.dart';

class CharacterRemoteDataSource {
  final ApiClient apiClient;

  CharacterRemoteDataSource(this.apiClient);

  Future<List<CharacterModel>> getCharacters({int page = 1}) async {
    try {
      final response = await apiClient.get('/character?page=$page');
      final List results = response.data['results'];
      return results.map((e) => CharacterModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Error al obtener personajes: $e');
    }
  }

  Future<List<CharacterModel>> suggestCharacters(String query) async {
    final response = await apiClient.dio.get('/character', queryParameters: {
      'name': query,
    });
    final data = response.data['results'] as List;
    return data.map((json) => CharacterModel.fromJson(json)).toList();
  }

  Future<List<CharacterModel>> searchCharacters(String query,
      {String? status, String? gender}) async {
    final statusMap = {
      'Vivo': 'alive',
      'Muerto': 'dead',
      'Desconocido': 'unknown',
    };

    final genderMap = {
      'Hombre': 'male',
      'Mujer': 'female',
      'Sin género': 'genderless',
      'Desconocido': 'unknown',
    };

    final queryParams = {
      if (query.isNotEmpty) 'name': query,
      if (status != null && statusMap.containsKey(status))
        'status': statusMap[status],
      if (gender != null && genderMap.containsKey(gender))
        'gender': genderMap[gender],
    };

    print(
        "URL llamada: https://rickandmortyapi.com/api/character?$queryParams");

    try {
      final response =
          await apiClient.dio.get('/character', queryParameters: queryParams);
      final data = response.data['results'] as List;
      return data.map((json) => CharacterModel.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        print(
            "Error 404: No se encontraron resultados para la búsqueda con estos filtros");
        return [];
      }
      throw e;
    }
  }
}
