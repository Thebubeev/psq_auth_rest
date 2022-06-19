import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psq/entities/sms_entity.dart';
import 'package:psq/entities/user_entity.dart';
import 'package:psq/entities/verify_sms_entity.dart';
import 'package:psq/internet_storage/internet_storage_api.dart';
import 'package:psq/preference_storage/preference_storage_impl.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final internetStorageApi = InternetStorageApi();
  final preferenceStorage = PreferenceStorageImpl();
  SmsEntity smsEntity;
  VerifySmsEntity verifySmsEntity;
  UserEntity userEntity;

  UserBloc() : super(UserInitial()) {
    on<UserLoginEvent>((event, emit) async {
      emit(UserLoading());
      var value = await internetStorageApi.validatePhone(event.phone);
      if (value != null) {
        smsEntity = value;
        emit(UserLoginStateState(smsEntity,event.phone));
      } else {
        emit(UserErrorState("Ошибка подтверждения номера."));
      }
    });

    on<UserConfirmEvent>((event, emit) async {
      emit(UserLoading());
      var value = await internetStorageApi.verify(event.phone, event.code);
      if (value != null) {
        verifySmsEntity = value;
        emit(UserConfirmStateState(verifySmsEntity));
      } else {
        emit(UserErrorState("Ошибка подтверждения номера."));
      }
    });

    on<UserRegisterEvent>((event, emit) async {
      emit(UserLoading());
      var value = await internetStorageApi.register(
          event.phone, event.name, event.code);
      if (value != null) {
        userEntity = value;
        emit(UserRegisterStateState(userEntity));
      } else {
        emit(UserErrorState("Ошибка подтверждения номера."));
      }
    });
  }
}
