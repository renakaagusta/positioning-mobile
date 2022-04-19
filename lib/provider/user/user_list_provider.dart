import 'dart:async';

import 'package:positioning/data/model/user.dart';
import 'package:positioning/data/remote/api/user_service.dart';
import 'package:positioning/helpers/dio.dart';
import 'package:positioning/helpers/disposable_provider.dart';
import 'package:positioning/helpers/exception/http_exception.dart';
import 'package:positioning/utils/result_state.dart';

class UserListProvider extends DisposableProvider {
  UserService _userService = UserService(AppDio.getDio());

  ResultState _state = ResultState.Idle;
  List<User>? _resultUserList;
  String? _error;

  String? get error => _error;
  List<User>? get resultUserList => _resultUserList;
  Future<dynamic> getUserList() => _getUserList();
  ResultState get state => _state;

  Future<dynamic> _getUserList() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final result = await _userService.getUserList();
      if (result == null) {
        _state = ResultState.NoData;
        notifyListeners();
      } else {
        _state = ResultState.HasData;
        _resultUserList = result;
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
