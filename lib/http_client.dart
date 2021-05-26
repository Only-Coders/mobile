import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/navigation.dart';
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
          print(error.response.requestOptions.path);
          if (error.response.statusCode != 401) {
            return handler.next(error);
          }
          if (error.response.requestOptions.path == "/api/auth/refresh") {
            await UserStorage.removeToken();
            NavigationService.instance.navigateToReplacement("/login");
          }
          AuthService _authService = AuthService();
          await _authService.refreshToken();
          return _retry(error.requestOptions);
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
}
