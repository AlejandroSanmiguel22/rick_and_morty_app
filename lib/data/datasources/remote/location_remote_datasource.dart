import 'package:dio/dio.dart';
import '../../models/location_model.dart';

class LocationRemoteDataSource {
  final Dio dio;

  LocationRemoteDataSource(this.dio);

  Future<List<LocationModel>> getLocations() async {
    try {
      final response = await dio.get("https://rickandmortyapi.com/api/location");
      final List results = response.data['results'];
      return results.map((e) => LocationModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Error al obtener ubicaciones');
    }
  }
}
