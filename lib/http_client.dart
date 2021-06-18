import 'package:dio/dio.dart';
import 'package:mobile/services/auth.dart';
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
        onError: (error, handler) async {
          if (error.response.statusCode != 401) {
            return handler.next(error);
          }
          _dio.interceptors.requestLock.lock();
          _dio.interceptors.responseLock.lock();
          _dio.interceptors.errorLock.lock();

          AuthService _authService = AuthService();
          await _authService.refreshToken();

          _dio.interceptors.requestLock.unlock();
          _dio.interceptors.responseLock.unlock();
          _dio.interceptors.errorLock.unlock();
          return handler.resolve(await _retry(error.requestOptions));
        },
      ),
    );
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = new Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
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

  Future<Response> putRequest(String url, dynamic data) async {
    return _dio.put(url, data: data);
  }

  Future<Response> patchRequest(String url, dynamic data) async {
    return _dio.patch(url, data: data);
  }
}
