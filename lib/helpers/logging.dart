import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

class Logging extends Interceptor {
  Logger? logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    print('RESULT : ${response.data}');
    return super.onResponse(response, handler);
  }
}