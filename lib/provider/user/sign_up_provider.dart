import 'dart:async';

import 'package:positioning/data/remote/api/user_service.dart';
import 'package:positioning/helpers/dio.dart';
import 'package:positioning/helpers/disposable_provider.dart';
import 'package:positioning/utils/result_state.dart';

class SignUpProvider extends DisposableProvider {
  final UserService _userService = UserService(AppDio.getDio());
  
  ResultState _state = ResultState.Idle;
  String? _userId;
  String? _error;
  
  String? get userId => _userId;
  String? get error => _error;
  Future<dynamic> signUp(Map<String, String> body) => _signUp(body);
  
  ResultState get state => _state;

  Future<dynamic> _signUp(Map<String, String> body) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final result = await _userService.signUp(body);
      if (result == null) {
        _state = ResultState.NoData;
        notifyListeners();
      } else {
        _state = ResultState.HasData;
        _userId = result;
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
