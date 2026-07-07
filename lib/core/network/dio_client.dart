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

          if (token != null &&
              !options.headers.containsKey('Authorization')) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            await _secureStorage.deleteTokens();
          }

          return handler.next(error);
        },
      ),
    );
  }
}
