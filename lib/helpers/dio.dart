import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:positioning/helpers/logging.dart';

class AppDio {
  static getDio() {
    late Dio dio;
    BaseOptions options = BaseOptions(
      baseUrl: dotenv.env['API_URL'] ?? "http://10.0.2.2:3000",
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      receiveDataWhenStatusError: false,
      connectTimeout: 30000,
      receiveTimeout: 3000,
    );
    dio = Dio(options)..interceptors.add(Logging());
    return dio;
  }
}