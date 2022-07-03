import 'dart:async';

import 'package:positioning/data/local/preferences/user_local.dart';
import 'package:positioning/data/model/user.dart';
import 'package:positioning/data/remote/api/user_service.dart';
import 'package:positioning/helpers/dio.dart';
import 'package:positioning/helpers/disposable_provider.dart';
import 'package:positioning/helpers/exception/http_exception.dart';
import 'package:positioning/helpers/shared_preferences.dart';
import 'package:positioning/utils/result_state.dart';

class UpdateUserPhotoProvider extends DisposableProvider{
  UserService _userService = UserService(AppDio.getDio());
  UserLocal _userLocal = UserLocal(SharedPrefs.instance);

  ResultState _state = ResultState.Idle;
  String? _resultUpdateUserPhoto;
  String? _error;

  String? get error => _error;
  String? get resultUpdateUserPhoto => _resultUpdateUserPhoto;
  Future<dynamic> updateUserPhoto(String userId, Map<String, String> body) => _updateUserPhoto(userId, body);
  ResultState get state => _state;

  Future<dynamic> _updateUserPhoto(String userId, Map<String, String> body) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final result = await _userService.updateUserPhoto(userId, body);
      if (result == null) {
        _state = ResultState.NoData;
        notifyListeners();
      } else {
        _state = ResultState.HasData;
        _resultUpdateUserPhoto = result;
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
