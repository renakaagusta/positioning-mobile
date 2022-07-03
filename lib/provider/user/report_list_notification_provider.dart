import 'dart:async';

import 'package:positioning/data/model/report.dart';
import 'package:positioning/data/remote/api/report_service.dart';
import 'package:positioning/helpers/dio.dart';
import 'package:positioning/helpers/disposable_provider.dart';
import 'package:positioning/helpers/exception/http_exception.dart';
import 'package:positioning/utils/result_state.dart';

class ReportListNotificationProvider extends DisposableProvider {
  ReportService _reportService = ReportService(AppDio.getDio());

  ResultState _state = ResultState.Idle;
  List<Report>? _resultReportList;
  String? _error;

  String? get error => _error;
  List<Report>? get resultReportList => _resultReportList;
  Future<dynamic> getReportList() => _getReportList();
  ResultState get state => _state;

  Future<dynamic> _getReportList() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final result = await _reportService.getReportList();
      if (result == null) {
        _state = ResultState.NoData;
        notifyListeners();
      } else {
        _state = ResultState.HasData;
        _resultReportList = result;
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
    _state = ResultState.Idle;
  }
}
