import 'dart:convert';

ResponseApi responseApiFromJson(String str) =>
    ResponseApi.fromJson(json.decode(str));

String responseApiToJson(ResponseApi data) => json.encode(data.toJson());

class ResponseApi {
  ResponseApi({
    required this.msg,
    required this.success,
    this.error,
    this.data,
  });

  late String msg;
  late bool success;
  String? error;
  dynamic data;

  ResponseApi.fromJson(Map<String, dynamic> json) {
    msg = json["msg"];
    success = json["success"];
    error = json["error"] ?? 'No error';
    try {
      data = json["data"] ?? 'No data';
    } on Exception catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "success": success,
        "error": error,
        "data": data,
      };
}
