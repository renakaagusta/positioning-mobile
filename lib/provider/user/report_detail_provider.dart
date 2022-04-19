import 'dart:async';

import 'package:positioning/data/model/report.dart';
import 'package:positioning/data/remote/api/report_service.dart';
import 'package:positioning/helpers/dio.dart';
import 'package:positioning/helpers/disposable_provider.dart';
import 'package:positioning/helpers/exception/http_exception.dart';
import 'package:positioning/utils/result_state.dart';

class ReportDetailProvider extends DisposableProvider{
  ReportService _reportService = ReportService(AppDio.getDio());

  ResultState _state = ResultState.Idle;
  Report? _resultReportDetail;
  String? _error;

  String? get error => _error;
  Report? get resultReportDetail => _resultReportDetail;
  Future<dynamic> getReportDetail(String reportId) =>
      _getReportDetail(reportId);
  ResultState get state => _state;

  Future<dynamic> _getReportDetail(String reportId) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final result = await _reportService.getProfile(reportId);
      if (result == null) {
        _state = ResultState.NoData;
        notifyListeners();
      } else {
        _state = ResultState.HasData;
        _resultReportDetail = result;
        notifyListeners();
      }
    } on HttpException catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _error = '$e';
    }
  }

  @override
  void disposeValues() {
  }
}
