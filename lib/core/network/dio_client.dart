import 'package:dio/dio.dart';
import '../secure_storage/secure_storage_manager.dart';

class DioClient {
  final Dio dio;
  final SecureStorageManager _secureStorage;
  final String baseUrl;

  DioClient({
    required this.baseUrl,
    required SecureStorageManager secureStorage,
    Dio? dioClient,
  })  : _secureStorage = secureStorage,
        dio = dioClient ?? Dio() {
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);
    dio.options.sendTimeout = const Duration(seconds: 15);

    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.getAccessToken();
          if (token != null && !options.headers.containsKey('Authorization')) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            final requestOptions = error.requestOptions;
            
            // Avoid infinite loops if refreshing token fails
            if (requestOptions.path.contains('/api/v1/auth/refresh')) {
              await _secureStorage.deleteTokens();
              return handler.next(error);
            }

            try {
              final newAccessToken = await _refreshToken();
              if (newAccessToken != null) {
                // Clone headers and retry request
                final headers = Map<String, dynamic>.from(requestOptions.headers);
                headers['Authorization'] = 'Bearer $newAccessToken';

                final response = await dio.request(
                  requestOptions.path,
                  data: requestOptions.data,
                  queryParameters: requestOptions.queryParameters,
                  options: Options(
                    method: requestOptions.method,
                    headers: headers,
                    contentType: requestOptions.contentType,
                    responseType: requestOptions.responseType,
                  ),
                );
                return handler.resolve(response);
              }
            } catch (e) {
              await _secureStorage.deleteTokens();
              return handler.next(error);
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<String?> _refreshToken() async {
    final refreshToken = await _secureStorage.getRefreshToken();
    if (refreshToken == null) return null;

    final refreshDio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    try {
      final response = await refreshDio.post(
        '/api/v1/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final newAccessToken = data['accessToken'] as String?;
        final newRefreshToken = data['refreshToken'] as String?;
        
        if (newAccessToken != null) {
          await _secureStorage.saveAccessToken(newAccessToken);
        }
        if (newRefreshToken != null) {
          await _secureStorage.saveRefreshToken(newRefreshToken);
        }
        return newAccessToken;
      }
    } catch (e) {
      await _secureStorage.deleteTokens();
      rethrow;
    }
    return null;
  }
}
