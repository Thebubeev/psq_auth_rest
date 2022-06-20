class UserInfoEntity {
  bool result;
  UserInfoDataEntity data;
  UserErrorDataEntity error;

  UserInfoEntity({this.result, this.data, this.error});

  factory UserInfoEntity.fromJson(Map<String, dynamic> data) {
    return UserInfoEntity(
        result: data['result'],
        data: UserInfoDataEntity.fromJson(data['data']),
        error: UserErrorDataEntity.fromJson(data['error']));
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

class UserErrorDataEntity {
  final String text;

  UserErrorDataEntity({this.text});

  factory UserErrorDataEntity.fromJson(Map<String, dynamic> json) {
    return UserErrorDataEntity(text: json['text']);
  }

  Map<String, dynamic> toJson() => {
        'error': text,
      };
}
