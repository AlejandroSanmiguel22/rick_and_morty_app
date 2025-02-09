import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  ApiClient()
      : dio = Dio(BaseOptions(
          baseUrl: 'https://rickandmortyapi.com/api',
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        )) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('[API REQUEST] ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('[API RESPONSE] ${response.statusCode} ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('[API ERROR] ${e.message}');
        return handler.next(e);
      },
    ));
  }

  Future<Response> get(String endpoint) async {
    return await dio.get(endpoint);
  }
}
