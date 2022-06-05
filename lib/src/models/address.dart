import 'dart:convert';

// import 'dart:developer';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {
  Address({
    this.id,
    required this.idUser,
    required this.direccion,
    required this.barrio,
    required this.especificacion,
    required this.lat,
    required this.lng,
  });

  String? id;
  late String idUser;
  late String direccion;
  late String barrio;
  late String especificacion;
  late double lat;
  late double lng;
  List<Address>? toList = [];

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"] is int ? json["id"].toString() : json["id"],
        idUser: json["id_user"] is int
            ? json["id_user"].toString()
            : json["id_user"],
        direccion: json["direccion"] ?? "",
        barrio: json["barrio"] ?? "",
        especificacion: json["especificacion"],
        lat: json["lat"] is String ? double.parse(json["lat"]) : json["lat"],
        lng: json["lng"] is String ? double.parse(json["lng"]) : json["lng"],
      );

  Address.fromJsonToList(List<dynamic> jsonList) {
    // print(jsonList.runtimeType);
    if (jsonList.isNotEmpty) {
      for (var element in jsonList) {
        Address categoria = Address.fromJson(element);
        toList!.add(categoria);
      }
    } else {
      toList = [];
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "direccion": direccion,
        "barrio": barrio,
        "especificacion": especificacion,
        "lat": lat,
        "lng": lng,
      };
}
