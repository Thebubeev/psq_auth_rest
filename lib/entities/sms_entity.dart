class SmsEntity {
  bool result;
  SmsDataEntity data;
  List<dynamic> error;

  SmsEntity({this.result, this.data, this.error});

  factory SmsEntity.fromJson(Map<String, dynamic> data) {
    List<String> errors = [];

    if (data.containsKey('error')) {
      Map<String, Object> errs = data['error'];

      errs.forEach((key, value) {
        List<String> list = List<String>.from(value);
        errors.addAll(list);
      });
    }

    return SmsEntity(
        result: data['result'],
        data: SmsDataEntity.fromJson(data['data']),
        error: errors);
  }
}

class SmsDataEntity {
  final int code;

  SmsDataEntity({this.code});

  factory SmsDataEntity.fromJson(Map<String, dynamic> data) {
    return SmsDataEntity(
      code: data['code']
    );
  }

    Map<String, dynamic> toJson() => {
        "code": code,
      };
}
