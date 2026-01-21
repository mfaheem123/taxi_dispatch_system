


import 'package:dio/dio.dart';

class DioService {
  static final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 50),
      receiveTimeout: const Duration(seconds: 50),
      headers: {
        'Connection': 'keep-alive',
        'Content-Type': 'application/json',
      },
    ),
  )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (!handler.isCompleted) {
            handler.resolve(response); // ✅ web safe
          }
        },
        onError: (error, handler) {
          if (!handler.isCompleted) {
            handler.reject(error);
          }
        },
      ),
    );
}
