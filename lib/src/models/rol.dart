import 'dart:convert';

Rol rolFromJson(String str) => Rol.fromJson(json.decode(str));

String rolToJson(Rol data) => json.encode(data.toJson());

class Rol {
  Rol({
    required this.id,
    required this.nombre,
    required this.imagen,
    required this.route,
  });

  String id;
  String nombre;
  String imagen;
  String route;

  factory Rol.fromJson(Map<String, dynamic> json) => Rol(
        id: json["id"] is int ? json["id"].toString() : json["id"],
        nombre: json["nombre"],
        imagen: json["imagen"],
        route: json["route"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "imagen": imagen,
        "route": route,
      };
}
