// To parse this JSON data, do
//
//     final orden = ordenFromJson(jsonString);
import 'dart:convert';
import 'dart:developer';

import 'package:reciclon_client/src/models/address.dart';
import 'package:reciclon_client/src/models/user.dart';

Orden ordenFromJson(String str) => Orden.fromJson(json.decode(str));

String ordenToJson(Orden data) => json.encode(data.toJson());

class Orden {
  Orden({
    this.id,
    required this.idUser,
    this.idRecolector,
    required this.idDireccion,
    required this.idEmpresa,
    required this.lat,
    required this.lng,
    this.status,
    this.timestamp,
    this.total,
    this.cliente,
    this.recolector,
    this.direccion,
  });

  String? id;
  late String idUser;
  String? idRecolector;
  late String idDireccion;
  late String idEmpresa;
  late double lat;
  late double lng;
  String? status;
  int? timestamp;
  double? total = 0;
  User? cliente;
  User? recolector;
  Address? direccion;
  List<Orden> toList = [];

  factory Orden.fromJson(Map<String, dynamic> json) => Orden(
        id: json["id"] is int ? json["id"].toString() : json["id"],
        idUser: json["id_user"] is int
            ? json["id_user"].toString()
            : json["id_user"],
        idRecolector: json["id_recolector"] == null
            ? ""
            : json["id_recolector"] is int
                ? json["id_recolector"].toString()
                : json["id_recolector"],
        idDireccion: json["id_direccion"] is int
            ? json["id_direccion"].toString()
            : json["id_direccion"],
        idEmpresa: json["id_empresa"] is int
            ? json["id_empresa"].toString()
            : json["id_empresa"],
        lat: json["lat"] is String ? double.parse(json["lat"]) : json["lat"],
        lng: json["lng"] is String ? double.parse(json["lng"]) : json["lng"],
        status: json["status"] ?? "",
        timestamp: json["timestamp"] is String
            ? int.parse(json["timestamp"])
            : json["timestamp"],
        // cliente: json["cliente"] is String
        //     ? userFromJson(json["cliente"])
        //     : User.fromJson(json["cliente"]),
        // recolector: json["recolector"] is String
        //     ? userFromJson(json["recolector"])
        //     : User.fromJson(json["recolector"]),
        // direccion: json['direccion'] is String
        //     ? addressFromJson(json['direccion'])
        //     : Address.fromJson(json['direccion']),
        cliente: json['cliente'] is String
            ? userFromJson(json['cliente'])
            : json['cliente'] is User
                ? json['cliente']
                : User.fromJson(json['cliente'] ?? {}),
        recolector: json['recolector'] is String
            ? userFromJson(json['recolector'])
            : json['recolector'] is User
                ? json['recolector']
                : User.fromJson(json['recolector'] ?? {}),
        direccion: json['direccion'] is String
            ? addressFromJson(json['direccion'])
            : json['direccion'] is Address
                ? json['direccion']
                : Address.fromJson(json['direccion'] ?? {}),
        total: json["total"] == null
            ? null
            : json["total"] is String
                ? double.parse(json["total"])
                : json["total"],
      );

  Orden.fromJsonList(List<dynamic>? jsonList) {
    // inspect(jsonList);
    // List<Orden> toList = [];
    if (jsonList != null) {
      if (jsonList.isNotEmpty) {
        for (Map<String, dynamic> element in jsonList) {
          Orden orden = Orden.fromJson(element);
          toList.add(orden);
        }
      } else {
        toList = [];
      }
    } else {
      toList = [];
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "id_recolector": idRecolector,
        "id_direccion": idDireccion,
        "id_empresa": idEmpresa,
        "lat": lat,
        "lng": lng,
        "status": status,
        "timestamp": timestamp,
        "total": total,
        'client': cliente,
        'direccion': direccion,
      };
}
