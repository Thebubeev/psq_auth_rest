class UserInfoEntity {
  bool result;
  UserInfoDataEntity data;
  UserInfoErrorDataEntity error;

  UserInfoEntity({this.result, this.data, this.error});

  factory UserInfoEntity.fromJson(Map<String, dynamic> data) {
    return UserInfoEntity(
        result: data['result'],
        data: UserInfoDataEntity.fromJson(data['data']),
        error: UserInfoErrorDataEntity.fromJson(data['error']));
  }

  Map<String, dynamic> toJson() =>
      {'result': result, 'data': data.toJson(), 'error': error.toJson()};
}

class UserInfoDataEntity {
  final String phone;
  final String name;
  final int code;

  UserInfoDataEntity({this.phone, this.name, this.code});

  factory UserInfoDataEntity.fromJson(Map<String, dynamic> json) {
    return UserInfoDataEntity(
        phone: json['phone'], name: json['name'], code: json['code']);
  }

  Map<String, dynamic> toJson() => {'phone': phone, 'name': name, 'code': code};
}

class UserInfoErrorDataEntity {
  final String text;

  UserInfoErrorDataEntity({this.text});

  factory UserInfoErrorDataEntity.fromJson(Map<String, dynamic> json) {
    return UserInfoErrorDataEntity(text: json['text']);
  }

  Map<String, dynamic> toJson() => {
        'error': text,
      };
}
