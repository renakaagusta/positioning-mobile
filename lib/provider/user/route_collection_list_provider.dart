import 'dart:async';

import 'package:positioning/data/model/route_collection.dart';
import 'package:positioning/data/remote/api/route_service.dart';
import 'package:positioning/helpers/dio.dart';
import 'package:positioning/helpers/disposable_provider.dart';
import 'package:positioning/helpers/exception/http_exception.dart';
import 'package:positioning/utils/result_state.dart';

class RouteCollectionListProvider extends DisposableProvider {
  RouteCollectionService _routeCollectionService = RouteCollectionService(AppDio.getDio());

  ResultState _state = ResultState.Idle;
  List<RouteCollection>? _resultRouteCollectionList;
  String? _error;

  String? get error => _error;
  List<RouteCollection>? get resultRouteCollectionList => _resultRouteCollectionList;
  Future<dynamic> getRouteCollectionList() => _getRouteCollectionList();
  ResultState get state => _state;

  Future<dynamic> _getRouteCollectionList() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final result = await _routeCollectionService.getRouteCollectionList();
      if (result == null) {
        _state = ResultState.NoData;
        notifyListeners();
      } else {
        _state = ResultState.HasData;
        _resultRouteCollectionList = result;
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
