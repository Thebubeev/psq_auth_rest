class UserEntity {
  bool result;
  UserDataEntity data;
  List<dynamic> error;

  UserEntity({this.result, this.data, this.error});

  factory UserEntity.fromJson(Map<String, dynamic> data) {
    List<String> errors = [];

    if (data.containsKey('error')) {
      Map<String, Object> errs = data['error'];

      errs.forEach((key, value) {
        List<String> list = List<String>.from(value);
        errors.addAll(list);
      });
    }

    return UserEntity(
        result: data['result'],
        data: UserDataEntity.fromJson(data['data']),
        error: errors);
  }
}

class UserDataEntity {
  final String phone;
  final String name;
  final int code;

  UserDataEntity({this.phone, this.name, this.code});

  factory UserDataEntity.fromJson(Map<String, dynamic> json) {
    return UserDataEntity(
        phone: json['phone'], name: json['name'], code: json['code']);
  }

  Map<String, dynamic> toJson() =>{
    'phone':phone, 
    'name': name,
    'code': code.toString()
  };
}
