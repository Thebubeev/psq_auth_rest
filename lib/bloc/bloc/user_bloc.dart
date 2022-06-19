import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psq/entities/sms_entity.dart';
import 'package:psq/entities/user_entity.dart';
import 'package:psq/entities/verify_sms_entity.dart';
import 'package:psq/internet_storage/internet_storage_api.dart';
import 'package:psq/preference_storage/preference_storage_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final internetStorageApi = InternetStorageApi();
  final preferenceStorage = PreferenceStorageImpl();
  SmsEntity smsEntity;
  VerifySmsEntity verifySmsEntity;

  UserInfoEntity userEntity;
  UserInfoDataEntity userInfoDataEntity;

  UserBloc() : super(UserInitial()) {
    on<UserInitEvent>((event, emit) async {
      final currentUser = await getUserFromCache();
      emit(UserData(userInfoDataEntity: currentUser));
    });

    on<UserValidatePhoneEvent>((event, emit) async {
      emit(UserLoading());
      var value = await internetStorageApi.validatePhone(event.phone);
      if (value != null) {
        smsEntity = value;
        emit(UserValidatePhoneState(smsEntity));
      } else {
        emit(UserErrorState("Ошибка подтверждения номера val."));
      }
    });

    on<UserVerifyEvent>((event, emit) async {
      emit(UserLoading());
      var value = await internetStorageApi.verify(event.phone, event.code);
      if (value != null) {
        verifySmsEntity = value;
        emit(UserVerifyState(verifySmsEntity));
      } else {
        emit(UserErrorState("Ошибка подтверждения номера ver."));
      }
    });

    on<UserRegisterEvent>((event, emit) async {
      emit(UserLoading());
      var value = await internetStorageApi.register(
          event.phone, event.name, event.code);
      if (value != null) {
        userEntity = value;
        final userInfoDataEntity = userEntity.data;
        emit(UserRegisterState(userInfoDataEntity));
        preferenceStorage.setUser(userInfoDataEntity);
      } else {
        emit(UserErrorState("Ошибка подтверждения номера reg."));
      }
    });

    on<UserLogoutEvent>((event, emit) async {
      final currentUser = await getUserFromCache();
      emit(UserLoading());
      if (currentUser != null) {
        emit(UserLogoutState());
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.clear();
      } else {
        emit(UserErrorState("Не удалось выйти."));
      }
    });
  }

  Future<UserInfoDataEntity> getUserFromCache() async {
    return await preferenceStorage.getUser();
  }
}
