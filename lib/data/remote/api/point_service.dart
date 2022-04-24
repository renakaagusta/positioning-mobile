import 'package:dio/dio.dart';
import 'package:positioning/data/model/api_response.dart';
import 'package:positioning/data/model/point_collection.dart';
import 'package:positioning/helpers/exception/http_exception.dart';

class PointCollectionService {
  late Dio _dio;

  PointCollectionService(Dio dio) {
    _dio = dio;
  }

  Future<List<PointCollection>> getPointCollectionList() async {
    try {
      Response response = await _dio.get(_dio.options.baseUrl + '/point-collections');
      ApiResponse apiResponse = ApiResponse.fromJson(response.data);
      if (apiResponse.status == 'success') {
        List<PointCollection> response = apiResponse.data['pointCollections'].map<PointCollection>(
                (news) => PointCollection.fromJson(news))
            .toList();
        return response;
      } else {
        throw HttpException(apiResponse.error?? apiResponse.message!);
      }
    } catch (error) {
      rethrow;
    }
  }
}
