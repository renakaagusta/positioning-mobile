import 'dart:async';

import 'package:positioning/data/local/preferences/auth_local.dart';
import 'package:positioning/data/model/auth.dart';
import 'package:positioning/data/remote/api/auth_service.dart';
import 'package:positioning/helpers/dio.dart';
import 'package:positioning/helpers/disposable_provider.dart';
import 'package:positioning/helpers/shared_preferences.dart';
import 'package:positioning/utils/result_state.dart';

class AuthProvider extends DisposableProvider {
  final AuthService _authService = AuthService(AppDio.getDio());
  final AuthLocal _authLocal = AuthLocal(SharedPrefs.instance);

  ResultState _state = ResultState.Idle;
  String? _accessToken;
  String? _refreshToken;
  String? _userId;
  String? _error;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  String? get userId => _userId;
  String? get error => _error;
  Future<dynamic> signIn(Map<String, String> body) => _signIn(body);
  Future<dynamic> saveToMemory() => _saveToMemory();
  Future<dynamic> readFromMemory() => _readFromMemory();
  Future<bool> removeFromMemory() => _removeFromMemory();

  ResultState get state => _state;

  Future<dynamic> _signIn(Map<String, String> body) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final result = await _authService.signIn(body);
      if (result == null) {
        _state = ResultState.NoData;
        notifyListeners();
      } else {
        _state = ResultState.HasData;
        _accessToken = result.accessToken!;
        _refreshToken = result.refreshToken!;
        _userId = result.userId!;
        notifyListeners();
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _error = '$e';
    }
  }

  Future<bool> _saveToMemory() async {
    try {
      return await _authLocal
          .save({'accessToken': _accessToken ?? '', 'refreshToken': _refreshToken ?? '', 'userId': _userId ?? ''});
    } catch (e) {
      rethrow;
    }
  }

  Future<Authentication?> _readFromMemory() async {
    try {
      Authentication? auth = await _authLocal.get();
      _accessToken = auth?.accessToken;
      _refreshToken = auth?.refreshToken;
      _userId = auth?.userId;
      return auth;
    } catch (e) {
      return null;
    }
  }

  Future<bool> _removeFromMemory() async {
    try {
      return await _authLocal.delete();
    } catch (e) {
      rethrow;
    }
  }

  @override
  void disposeValues() {
    _state = ResultState.Idle;
    _accessToken = null;
    _refreshToken = null;
    _error = null;
  }
}
