part of 'user_bloc.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoginStateState extends UserState {
  final SmsEntity smsEntity;
  final String phone;

  UserLoginStateState(this.smsEntity, this.phone);
}

class UserConfirmStateState extends UserState {
  final VerifySmsEntity verifySmsEntity;

  UserConfirmStateState(this.verifySmsEntity);
}

class UserRegisterStateState extends UserState {
  final UserEntity userEntity;

  UserRegisterStateState(this.userEntity);
}

class UserErrorState extends UserState {
  final String error;

  UserErrorState(this.error);
}
