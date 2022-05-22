import 'dart:async';

import 'package:positioning/data/remote/api/report_service.dart';
import 'package:positioning/helpers/dio.dart';
import 'package:positioning/helpers/disposable_provider.dart';
import 'package:positioning/utils/result_state.dart';

class ReportUpdateProvider extends DisposableProvider {
  final ReportService _reportService = ReportService(AppDio.getDio());
  
  ResultState _state = ResultState.Idle;
  String? _reportId;
  String? _error;
  
  String? get reportId => _reportId;
  String? get error => _error;
  Future<dynamic> updateReport(Map<String, dynamic> body, String id) => _updateReport(body, id);
  
  ResultState get state => _state;

  Future<dynamic> _updateReport(Map<String, dynamic> body, String id) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final result = await _reportService.updateReport(body, id);
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
