part of 'user_bloc.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserData extends UserState {
  final UserInfoDataEntity userInfoDataEntity;
  UserData({this.userInfoDataEntity});
}

class UserLoading extends UserState {}

class UserValidatePhoneState extends UserState {
  final SmsEntity smsEntity;

  UserValidatePhoneState(this.smsEntity);
}

class UserVerifyState extends UserState {
  final VerifySmsEntity verifySmsEntity;

  UserVerifyState(this.verifySmsEntity);
}

class UserRegisterState extends UserState {
  final UserInfoDataEntity userEntity;

  UserRegisterState(this.userEntity);
}

class UserLogoutState extends UserState {}

class UserErrorState extends UserState {
  final String error;
  UserErrorState(this.error);
}

class UserValidateErrorState extends UserState {
  final String error;

  UserValidateErrorState(this.error);
}

class UserVerifyErrorState extends UserState {
  final String error;

  UserVerifyErrorState(this.error);
}

class UserRegisterErrorState extends UserState {
  final String error;

  UserRegisterErrorState(this.error);
}
