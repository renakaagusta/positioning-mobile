import 'package:dio/dio.dart';
import 'package:positioning/data/model/api_response.dart';
import 'package:positioning/data/model/route_collection.dart';
import 'package:positioning/helpers/exception/http_exception.dart';

class RouteCollectionService {
  late Dio _dio;

  RouteCollectionService(Dio dio) {
    _dio = dio;
  }

  Future<RouteCollection> getRouteCollection(String routeCollectionId) async {
    try {
      Response response = await _dio.get(_dio.options.baseUrl + '/route-collections/${routeCollectionId}');
      ApiResponse apiResponse = ApiResponse.fromJson(response.data);
      if (apiResponse.status == 'success') {
        return RouteCollection.fromJson(apiResponse.data['route-collection']);
      } else {
        throw HttpException(apiResponse.error?? apiResponse.message!);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<RouteCollection>> getRouteCollectionList() async {
    try {
      Response response = await _dio.get(_dio.options.baseUrl + '/route-collections');
      ApiResponse apiResponse = ApiResponse.fromJson(response.data);
      if (apiResponse.status == 'success') {
        List<RouteCollection> response = apiResponse.data['route-collections'].map<RouteCollection>(
                (news) => RouteCollection.fromJson(news))
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
