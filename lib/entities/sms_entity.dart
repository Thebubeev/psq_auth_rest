class SmsEntity {
  bool result;
  SmsDataEntity data;
  SmsErrorDataEntity error;

  SmsEntity({this.result, this.data, this.error});

  factory SmsEntity.fromJson(Map<String, dynamic> data) {
    return SmsEntity(
        result: data['result'],
        data: SmsDataEntity.fromJson(data['data']),
        error: SmsErrorDataEntity.fromJson(data['error']));
  }
  
  
  Map<String, dynamic> toJson() =>
      {'result': result, 'data': data.toJson(), 'error': error.toJson()};
}

class SmsDataEntity {
  final int code;

  SmsDataEntity({this.code});

  factory SmsDataEntity.fromJson(Map<String, dynamic> data) {
    return SmsDataEntity(code: data['code']);
  }

  Map<String, dynamic> toJson() => {
        "code": code,
      };
}

class SmsErrorDataEntity {
  final String text;

  SmsErrorDataEntity({this.text});

  factory SmsErrorDataEntity.fromJson(Map<String, dynamic> json) {
    return SmsErrorDataEntity(text: json['text']);
  }

  Map<String, dynamic> toJson() => {
        'error': text,
      };
}
