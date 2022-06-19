part of 'user_bloc.dart';

abstract class UserEvent {}

class UserInitEvent extends UserEvent {}

class UserValidatePhoneEvent extends UserEvent {
  final String phone;

  UserValidatePhoneEvent(this.phone);
}

class UserVerifyEvent extends UserEvent {
  final int code;
  final String phone;

  UserVerifyEvent(this.code, this.phone);
}

class UserRegisterEvent extends UserEvent {
  final String phone;
  final String name;
  final int code;
  UserRegisterEvent({this.phone, this.name, this.code});
}


class UserLogoutEvent extends UserEvent{}