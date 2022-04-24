import 'dart:async';

import 'package:positioning/data/remote/api/report_service.dart';
import 'package:positioning/helpers/dio.dart';
import 'package:positioning/helpers/disposable_provider.dart';
import 'package:positioning/utils/result_state.dart';

class ReportCreateProvider extends DisposableProvider {
  final ReportService _reportService = ReportService(AppDio.getDio());
  
  ResultState _state = ResultState.Idle;
  String? _reportId;
  String? _error;
  
  String? get reportId => _reportId;
  String? get error => _error;
  Future<dynamic> createReport(Map<String, dynamic> body) => _createReport(body);
  
  ResultState get state => _state;

  Future<dynamic> _createReport(Map<String, dynamic> body) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final result = await _reportService.createReport(body);
      if (result == null) {
        _state = ResultState.NoData;
        notifyListeners();
      } else {
        _state = ResultState.HasData;
        _reportId = result;
        notifyListeners();
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _error = '$e';
    }
  }

  @override
  void disposeValues() {
    _state = ResultState.Idle;
    _error = null;
  }
}
