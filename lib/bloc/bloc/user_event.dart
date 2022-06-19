part of 'user_bloc.dart';

abstract class UserEvent {}

class UserInitEvent extends UserEvent {}

class UserRefreshEvent extends UserEvent {}

class UserLoginEvent extends UserEvent {
  final String phone;

  UserLoginEvent(this.phone);
}

class UserConfirmEvent extends UserEvent {
  final int code;
  final String phone;

  UserConfirmEvent(this.code, this.phone);
}

class UserRegisterEvent extends UserEvent {
  final String phone;
  final String name;
  final int code;
  UserRegisterEvent({this.phone, this.name, this.code});
}
