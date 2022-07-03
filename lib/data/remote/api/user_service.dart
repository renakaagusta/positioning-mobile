import 'package:dio/dio.dart';
import 'package:path/path.dart';
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

  Future<bool> updateUserData(String userId, Map<String, String> body) async {
    try {
      Response response = await _dio.put(_dio.options.baseUrl + '/users/' + userId, data: body);
      ApiResponse apiResponse = ApiResponse.fromJson(response.data);
      if (apiResponse.status == 'success') {
        return true;
      } else {
        throw HttpException(apiResponse.error?? apiResponse.message!);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<String> updateUserPhoto(String userId, Map<String, String> body) async {
    try {
      FormData formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(body['photo']!, filename: basename(body['photo']!)),
    });

      Response response = await _dio.put(_dio.options.baseUrl + '/users/' + userId + '/photo', data: formData);
      ApiResponse apiResponse = ApiResponse.fromJson(response.data);
      if (apiResponse.status == 'success') {
        return apiResponse.data['photoUrl'];
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
    } catch (e) {
      if (e is DioError) {
        throw HttpException("Username/email telah digunakan");
      } else {
        throw HttpException("Username/email telah digunakan");
      }
    }
  }
}
