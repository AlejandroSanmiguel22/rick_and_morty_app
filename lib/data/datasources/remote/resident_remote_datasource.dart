
import 'package:rick_and_morty/core/network/api_client.dart';
import 'package:rick_and_morty/data/models/character_model.dart';

class ResidentRemoteDataSource {
  final ApiClient apiClient;

  ResidentRemoteDataSource(this.apiClient);

  Future<CharacterModel> getResident(String url) async {
    try {
      final response = await apiClient.get(url);
      return CharacterModel.fromJson(response.data);
    } catch (e) {
      throw Exception("Error al obtener residente: ${e.toString()}");
    }
  }
}
