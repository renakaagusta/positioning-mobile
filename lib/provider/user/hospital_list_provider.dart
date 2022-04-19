import 'dart:async';

import 'package:positioning/data/model/user.dart';
import 'package:positioning/data/remote/api/user_service.dart';
import 'package:positioning/helpers/dio.dart';
import 'package:positioning/helpers/disposable_provider.dart';
import 'package:positioning/helpers/exception/http_exception.dart';
import 'package:positioning/utils/result_state.dart';

class HospitalListProvider extends DisposableProvider {
  UserService _userService = UserService(AppDio.getDio());

  ResultState _state = ResultState.Idle;
  List<User>? _resultHospitalList;
  String? _error;

  String? get error => _error;
  List<User>? get resultHospitalList => _resultHospitalList;
  Future<dynamic> getHospitalList() => _getHospitalList();
  ResultState get state => _state;

  Future<dynamic> _getHospitalList() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final result = await _userService.getUserList();
      if (result == null) {
        _state = ResultState.NoData;
        notifyListeners();
      } else {
        _state = ResultState.HasData;
        _resultHospitalList = result;
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
