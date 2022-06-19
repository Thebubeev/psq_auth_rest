import 'dart:convert';

import 'package:psq/entities/user_entity.dart';
import 'package:psq/preference_storage/preference_storage.dart';
import 'package:quiver/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin _Constants {
  static const String user = 'user';
}

class PreferenceStorageImpl implements PreferenceStorage {
  final _prefs = SharedPreferences.getInstance();

  @override
  Future<UserInfoDataEntity> getUser() async {
    final sharedPrefs = await _prefs;
    final jsonString = sharedPrefs.getString(_Constants.user);
    if (isBlank(jsonString)) {
      return null;
    } else {
      try {
        final json = jsonDecode(jsonString);
        return UserInfoDataEntity.fromJson(json);
      } catch (e) {
        return null;
      }
    }
  }

  @override
  Future setUser(UserInfoDataEntity user) async {
    if (user != null) {
      final jsonString = user.toJson();
      await _prefs.then(
          (value) => value.setString(_Constants.user, jsonEncode(jsonString)));
    } else {
      await _prefs.then((value) => value.remove(_Constants.user));
    }
  }
}
