import 'package:dio/dio.dart';
import '../../models/location_model.dart';

class LocationRemoteDataSource {
  final Dio dio;

  LocationRemoteDataSource(this.dio);

  Future<List<LocationModel>> getLocations() async {
    try {
      final response =
          await dio.get("https://rickandmortyapi.com/api/location");
      final List results = response.data['results'];
      return results.map((e) => LocationModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Error al obtener ubicaciones');
    }
  }

  Future<List<LocationModel>> suggestLocations(String query) async {
    try {
      final response = await dio
          .get("https://rickandmortyapi.com/api/location/?name=$query");
      final List results = response.data['results'];
      return results.map((e) => LocationModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Error al obtener sugerencias de ubicaciones');
    }
  }

  Future<List<LocationModel>> searchLocations(String query,
      {String? type, String? dimension}) async {
    try {
      Map<String, String> params = {};
      if (query.isNotEmpty) params["name"] = query;
      if (type != null && type.isNotEmpty) params["type"] = type;
      if (dimension != null && dimension.isNotEmpty)
        params["dimension"] = dimension;

      final response = await dio.get(
          "https://rickandmortyapi.com/api/location/",
          queryParameters: params);

      final List results = response.data['results'];
      return results.map((e) => LocationModel.fromJson(e)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return []; // Devuelve lista vacía si no hay resultados
      }
      throw Exception('Error al buscar ubicaciones');
    }
  }
}
