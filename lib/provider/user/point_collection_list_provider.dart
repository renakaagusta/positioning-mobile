import 'dart:async';

import 'package:positioning/data/model/point_collection.dart';
import 'package:positioning/data/remote/api/point_service.dart';
import 'package:positioning/helpers/dio.dart';
import 'package:positioning/helpers/disposable_provider.dart';
import 'package:positioning/helpers/exception/http_exception.dart';
import 'package:positioning/utils/result_state.dart';

class PointCollectionListProvider extends DisposableProvider {
  PointCollectionService _pointCollectionService = PointCollectionService(AppDio.getDio());

  ResultState _state = ResultState.Idle;
  List<PointCollection>? _resultPointCollectionList;
  String? _error;

  String? get error => _error;
  List<PointCollection>? get resultPointCollectionList => _resultPointCollectionList;
  Future<dynamic> getPointCollectionList() => _getPointCollectionList();
  ResultState get state => _state;

  Future<dynamic> _getPointCollectionList() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final result = await _pointCollectionService.getPointCollectionList();
      if (result == null) {
        _state = ResultState.NoData;
        notifyListeners();
      } else {
        _state = ResultState.HasData;
        _resultPointCollectionList = result;
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
