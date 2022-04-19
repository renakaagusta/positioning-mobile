import 'package:dio/dio.dart';
import 'package:positioning/data/model/api_response.dart';
import 'package:positioning/data/model/auth.dart';
import 'package:positioning/helpers/exception/http_exception.dart';

class AuthService {
  late Dio _dio;

  AuthService(Dio dio) {
    _dio = dio;
  }

  Future<Authentication> signIn(Map<String, String> body) async {
    try {
       Response response =
          await _dio.post(_dio.options.baseUrl + '/authentications', data: body);
      ApiResponse apiResponse = ApiResponse.fromJson(response.data);
      if (apiResponse.status == 'success') {
        return Authentication.fromJson(apiResponse.data);
      } else {
        throw HttpException(apiResponse.error ?? apiResponse.message!);
      }
    } catch (error) {
      rethrow;
    }
  }
}
