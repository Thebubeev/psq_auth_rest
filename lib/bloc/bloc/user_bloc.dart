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
      emit(UserInitial(userInfoDataEntity: currentUser));
    });

    on<UserValidatePhoneEvent>((event, emit) async {
      emit(UserLoading());
      final value = await internetStorageApi.validatePhone(event.phone);
      if (value.result == true) {
        smsEntity = value;
        emit(UserValidatePhoneState(smsEntity));
      } else {
        emit(UserValidateErrorState(value.error.text));
      }
    });

    on<UserVerifyEvent>((event, emit) async {
      emit(UserLoading());
      final value = await internetStorageApi.verify(event.phone, event.code);
      if (value.result == true) {
        verifySmsEntity = value;
        emit(UserVerifyState(verifySmsEntity));
      } else {
        emit(UserVerifyErrorState(value.error.text));
      }
    });

    on<UserRegisterEvent>((event, emit) async {
      emit(UserLoading());
      final value = await internetStorageApi.register(
          event.phone, event.name, event.code);
      if (value.result == true) {
        userEntity = value;
        final userInfoDataEntity = userEntity.data;
        emit(UserRegisterState(userInfoDataEntity));
        preferenceStorage.setUser(userInfoDataEntity);
      } else {
        emit(UserRegisterErrorState(value.error.text));
      }
    });

    on<UserLogoutEvent>((event, emit) async {
      final currentUser = await getUserFromCache();
      emit(UserLoading());
      if (currentUser != null) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.clear();
        emit(UserLogoutState());
      } else {
        emit(UserLogoutErrorState("Не удалось выйти."));
      }
    });
  }

  Future<UserInfoDataEntity> getUserFromCache() async {
    return await preferenceStorage.getUser();
  }
}
