import 'package:dio/dio.dart';
import 'package:positioning/data/model/api_response.dart';
import 'package:positioning/data/model/report.dart';
import 'package:positioning/helpers/exception/http_exception.dart';

class ReportService {
  late Dio _dio;

  ReportService(Dio dio) {
    _dio = dio;
  }

  Future<Report> getProfile(String reportId) async {
    try {
      Response response = await _dio.get(_dio.options.baseUrl + '/reports/${reportId}');
      ApiResponse apiResponse = ApiResponse.fromJson(response.data);
      if (apiResponse.status == 'success') {
        return Report.fromJson(apiResponse.data['report']);
      } else {
        throw HttpException(apiResponse.error?? apiResponse.message!);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Report>> getReportList() async {
    try {
      Response response = await _dio.get(_dio.options.baseUrl + '/reports');
      ApiResponse apiResponse = ApiResponse.fromJson(response.data);
      if (apiResponse.status == 'success') {
        List<Report> response = apiResponse.data['reports'].map<Report>(
                (news) => Report.fromJson(news))
            .toList();
        return response;
      } else {
        throw HttpException(apiResponse.error?? apiResponse.message!);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<String> createReport(Map<String, dynamic> body) async {
    try {
      Response response =
          await _dio.post(_dio.options.baseUrl + '/reports', data: body);
      ApiResponse apiResponse = ApiResponse.fromJson(response.data);
      if (apiResponse.status == 'success') {
        return apiResponse.data['reportId'];
      } else {
        throw HttpException(apiResponse.error?? apiResponse.message!);
      }
    } catch (error) {
      rethrow;
    }
  }
}
