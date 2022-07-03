import 'dart:async';

import 'package:positioning/data/local/preferences/user_local.dart';
import 'package:positioning/data/model/user.dart';
import 'package:positioning/data/remote/api/user_service.dart';
import 'package:positioning/helpers/dio.dart';
import 'package:positioning/helpers/disposable_provider.dart';
import 'package:positioning/helpers/exception/http_exception.dart';
import 'package:positioning/helpers/shared_preferences.dart';
import 'package:positioning/utils/result_state.dart';

class UpdateUserDataProvider extends DisposableProvider{
  UserService _userService = UserService(AppDio.getDio());
  UserLocal _userLocal = UserLocal(SharedPrefs.instance);

  ResultState _state = ResultState.Idle;
  bool? _resultUpdateUserData;
  String? _error;

  String? get error => _error;
  bool? get resultUpdateUserData => _resultUpdateUserData;
  Future<dynamic> updateUserData(String userId, Map<String, String> body) => _updateUserData(userId, body);
  ResultState get state => _state;

  Future<dynamic> _updateUserData(String userId, Map<String, String> body) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final result = await _userService.updateUserData(userId, body);
      if (result == null) {
        _state = ResultState.NoData;
        notifyListeners();
      } else {
        _state = ResultState.HasData;
        _resultUpdateUserData = result;
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
