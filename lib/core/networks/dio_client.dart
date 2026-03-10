import 'package:dio/dio.dart';

import 'api_urls.dart';


class DioClient {
  final Dio _dio;

  DioClient._internal()
      : _dio = Dio(
    BaseOptions(
      baseUrl: ApiUrls.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  ) {
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  //! Add token
  void setToken(String token) {
    _dio.options.headers["Authorization"] = "Bearer $token";
  }

  //! GET
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      return await _dio.get(path, queryParameters: queryParams);
    } catch (e) {
      rethrow;
    }
  }

  //! POST
  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  //! PUT
  Future<Response> patch(String path, {dynamic data}) async {
    try {
      return await _dio.patch(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  //! DELETE
  Future<Response> delete(
      String path, {
        Map<String, dynamic>? queryParams,
      }) async {
    try {
      return await _dio.delete(path, queryParameters: queryParams);
    } catch (e) {
      rethrow;
    }
  }
}
