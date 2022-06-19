class VerifySmsEntity {
  bool result;
  List<dynamic> data;
  List<dynamic> error;

  VerifySmsEntity({this.result, this.data, this.error});

  factory VerifySmsEntity.fromJson(Map<String, dynamic> json) {
    List<dynamic> data = [];
    List<String> errors = [];

    if (json.containsKey('data')) {
      Map<String, Object> info = json['data'];
      info.forEach((key, value) {
        List<String> list = List<String>.from(value);
        data.addAll(list);
      });
    }

    if (json.containsKey('error')) {
      Map<String, Object> errs = json['error'];
      errs.forEach((key, value) {
        List<String> list = List<String>.from(value);
        errors.addAll(list);
      });
    }

    return VerifySmsEntity(result: json['result'], data: data, error: errors);
  }
}
