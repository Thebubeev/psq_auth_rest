import 'package:psq/entities/user_entity.dart';

abstract class PreferenceStorage {
  Future<UserDataEntity> getUser();

  Future setUser(UserDataEntity user);
}
