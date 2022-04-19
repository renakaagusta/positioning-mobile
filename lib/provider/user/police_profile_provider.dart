import 'dart:async';

import 'package:positioning/data/local/preferences/user_local.dart';
import 'package:positioning/data/model/user.dart';
import 'package:positioning/data/remote/api/user_service.dart';
import 'package:positioning/helpers/dio.dart';
import 'package:positioning/helpers/disposable_provider.dart';
import 'package:positioning/helpers/exception/http_exception.dart';
import 'package:positioning/helpers/shared_preferences.dart';
import 'package:positioning/utils/result_state.dart';

class PoliceProfileProvider extends DisposableProvider{
  UserService _userService = UserService(AppDio.getDio());
  UserLocal _userLocal = UserLocal(SharedPrefs.instance);

  ResultState _state = ResultState.Idle;
  User? _resultPoliceProfile;
  String? _error;

  String? get error => _error;
  User? get resultPoliceProfile => _resultPoliceProfile;
  Future<dynamic> getPoliceProfile(String userId) =>
      _getPoliceProfile(userId);
  Future<dynamic> saveToMemory() =>
      _saveToMemory();
  Future<dynamic> readFromMemory() =>
      _readFromMemory();
  ResultState get state => _state;

  Future<dynamic> _getPoliceProfile(String userId) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final result = await _userService.getProfile(userId);
      if (result == null) {
        _state = ResultState.NoData;
        notifyListeners();
      } else {
        _state = ResultState.HasData;
        _resultPoliceProfile = result;
        notifyListeners();
      }
    } on HttpException catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _error = '$e';
    }
  }

  Future<bool> _saveToMemory() async {
    try {
      return await _userLocal
          .save(resultPoliceProfile!.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<User> _readFromMemory() async {
    try {
      User user = await _userLocal.get();
      _resultPoliceProfile = user;
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  void disposeValues() {
    _state = ResultState.Idle;
  }
}
