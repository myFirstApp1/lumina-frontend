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

            print('========== DIO REQUEST ==========');
            print('METHOD: ${options.method}');
            print('URL: ${options.uri}');
            print('TOKEN EXISTS: ${token != null}');
            print('TOKEN LENGTH: ${token?.length ?? 0}');

            if (token != null && token.trim().isNotEmpty) {
              options.headers['Authorization'] = 'Bearer ${token.trim()}';
            }

            options.headers['Content-Type'] = 'application/json';

            print(
              'AUTH HEADER EXISTS: '
                  '${options.headers['Authorization'] != null}',
            );
            print('=================================');

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