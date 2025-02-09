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
}
