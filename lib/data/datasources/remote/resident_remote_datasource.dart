import 'package:dio/dio.dart';
import 'package:rick_and_morty/data/models/character_model.dart';

class ResidentRemoteDataSource {
  final Dio dio;

  ResidentRemoteDataSource(this.dio);

  Future<CharacterModel> getResident(String url) async {
    try {
      final response = await dio.get(url);
      return CharacterModel.fromJson(response.data);
    } catch (e) {
      throw Exception("Error al obtener residente: ${e.toString()}");
    }
  }
}
