import 'package:dio/dio.dart';
import 'storage.dart';

class HttpClient {
  final String _baseUrl = "https://api.onlycoders.tech";
  Dio _dio;

  HttpClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
      ),
    );
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String token = await UserStorage.getToken();
          if (token != null) {
            options.headers["Authorization"] = "Bearer " + token;
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<Response> getRequest(String url, [Map<String, dynamic> params]) async {
    return _dio.get(url, queryParameters: params);
  }

  Future<Response> deleteRequest(String url,
      [Map<String, dynamic> params]) async {
    return _dio.delete(url, queryParameters: params);
  }

  Future<Response> postRequest(String url, dynamic data) async {
    return _dio.post(url, data: data);
  }
}
