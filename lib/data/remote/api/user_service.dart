import 'package:dio/dio.dart';
import 'package:positioning/data/model/api_response.dart';
import 'package:positioning/data/model/user.dart';
import 'package:positioning/helpers/exception/http_exception.dart';

class UserService {
  late Dio _dio;

  UserService(Dio dio) {
    _dio = dio;
  }

  Future<User> getProfile(String userId) async {
    try {
      Response response = await _dio.get(_dio.options.baseUrl + '/users/${userId}');
      ApiResponse apiResponse = ApiResponse.fromJson(response.data);
      if (apiResponse.status == 'success') {
        return User.fromJson(apiResponse.data['user']);
      } else {
        throw HttpException(apiResponse.error?? apiResponse.message!);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<User>> getUserList() async {
    try {
      Response response = await _dio.get(_dio.options.baseUrl + '/users');
      ApiResponse apiResponse = ApiResponse.fromJson(response.data);
      print("||||||||||||||||||||||||||||");
      print(apiResponse);
      if (apiResponse.status == 'success') {
        List<User> response = apiResponse.data['users'].map<User>(
                (user) => User.fromJson(user))
            .toList();
        return response;
      } else {
        throw HttpException(apiResponse.error?? apiResponse.message!);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<String> signUp(Map<String, String> body) async {
    try {
       Response response =
          await _dio.post(_dio.options.baseUrl + '/users', data: body);
      ApiResponse apiResponse = ApiResponse.fromJson(response.data);
      if (apiResponse.status == 'success') {
        return apiResponse.data['userId'];
      } else {
        throw HttpException(apiResponse.error?? apiResponse.message!);
      }
    } catch (error) {
      rethrow;
    }
  }
}
