// To parse this JSON data, do
//
//     final empresa = empresaFromJson(jsonString);

import 'dart:convert';

Empresa empresaFromJson(String str) => Empresa.fromJson(json.decode(str));

String empresaToJson(Empresa data) => json.encode(data.toJson());

class Empresa {
  Empresa({
    this.id,
    required this.idUser,
    this.estado,
    required this.nombre,
    required this.razonSocial,
    required this.telefono,
    required this.direccion,
    required this.email,
    required this.descripcion,
    this.categorias,
    this.imagen,
    this.toList,
  });

  String? id;
  late String idUser;
  String? estado;
  late String nombre;
  late String razonSocial;
  late String telefono;
  late String direccion;
  late String email;
  String? imagen;
  late String descripcion;
  List<dynamic>? categorias;
  List<Empresa>? toList = [];

  factory Empresa.fromJson(Map<String, dynamic> json) => Empresa(
        id: json["id"] != null
            ? json["id"] is int
                ? json["id"].toString()
                : json["id"]
            : '',
        idUser: json["id_user"] != null
            ? json["id_user"] is int
                ? json["id_user"].toString()
                : json["id_user"]
            : '',
        estado: json["estado"] ?? '',
        nombre: json["nombre"] != null ? json["nombre"] ?? '' : '',
        razonSocial:
            json["razon_social"] != null ? json["razon_social"] ?? '' : '',
        telefono: json["telefono"] != null ? json["telefono"] ?? '' : '',
        direccion: json["direccion"] != null ? json["direccion"] ?? '' : '',
        email: json["email"] != null ? json["email"] ?? '' : '',
        imagen: json["imagen"] != null ? json["imagen"] ?? '' : '',
        categorias:
            json["categorias"] == null ? [''] : json["categorias"] ?? [''],
        descripcion:
            json["descripcion"] != null ? json["descripcion"] ?? '' : '',
      );

  Empresa.fromJsonList(List<dynamic> jsonList) {
    if (jsonList.isNotEmpty) {
      for (var element in jsonList) {
        // inspect(element);
        Empresa empresa = Empresa.fromJson(element);
        toList!.add(empresa);
      }
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "estado": estado,
        "nombre": nombre,
        "razon_social": razonSocial,
        "telefono": telefono,
        "direccion": direccion,
        "email": email,
        "imagen": imagen,
        "descripcion": descripcion,
        "categorias": categorias,
      };
}
