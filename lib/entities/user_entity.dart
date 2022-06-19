class UserInfoEntity {
  bool result;
  UserInfoDataEntity data;
  List<dynamic> error;

  UserInfoEntity({this.result, this.data, this.error});

  factory UserInfoEntity.fromJson(Map<String, dynamic> data) {
    List<String> errors = [];

    if (data.containsKey('error')) {
      Map<String, Object> errs = data['error'];

      errs.forEach((key, value) {
        List<String> list = List<String>.from(value);
        errors.addAll(list);
      });
    }

    return UserInfoEntity(
        result: data['result'],
        data: UserInfoDataEntity.fromJson(data['data']),
        error: errors);
  }

  Map<String, dynamic> toJson() => {
        'result': result,
        'data': data.toJson(),
        'error': error.first.toString()
      };
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
