class VerifySmsEntity {
  bool result;
  List<dynamic> data;
  VerifySmsErrorDataEntity error;

  VerifySmsEntity({this.result, this.data, this.error});

  factory VerifySmsEntity.fromJson(Map<String, dynamic> json) {
    List<dynamic> data = [];

    if (json.containsKey('data')) {
      Map<String, Object> info = json['data'];
      info.forEach((key, value) {
        List<String> list = List<String>.from(value);
        data.addAll(list);
      });
    }

    return VerifySmsEntity(
        result: json['result'],
        data: data,
        error: VerifySmsErrorDataEntity.fromJson(json['error']));
  }

  Map<String, dynamic> toJson() =>
      {'result': result, 'data': data.toString(), 'error': error.toJson()};
}

class VerifySmsErrorDataEntity {
  final String text;

  VerifySmsErrorDataEntity({this.text});

  factory VerifySmsErrorDataEntity.fromJson(Map<String, dynamic> json) {
    return VerifySmsErrorDataEntity(text: json['text']);
  }

  Map<String, dynamic> toJson() => {
        'error': text,
      };
}
