import 'package:psq/entities/user_entity.dart';

abstract class PreferenceStorage {
  Future<UserInfoDataEntity> getUser();

  Future setUser(UserInfoDataEntity user);
}
