import 'dart:convert';

import 'package:positioning/data/model/auth.dart';
import 'package:positioning/helpers/exception/memory_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocal {
  late SharedPreferences _preferences;

  AuthLocal(SharedPreferences preferences) {
    _preferences = preferences;
  }

  Future<bool> save(Map<String, String> body) async {
    try {
     return _preferences.setString('auth', jsonEncode(body));
    } catch (error) {
      rethrow;
    }
  }

  Future<Authentication?> get() async {
     String? authJson = await _preferences.getString('auth');
     if(authJson == null) {
       throw MemoryException('Authentication not found');
     } else {
       return Authentication.fromJson(jsonDecode(authJson));
     }
  }

  Future<bool> delete() async {
    try {
     return _preferences.remove('auth');
    } catch (error) {
      throw MemoryException('Authentication not found on delete');
    }
  }
}
