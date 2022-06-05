import 'dart:convert';

Estado estadoFromJson(String str) => Estado.fromJson(json.decode(str));

String estadoToJson(Estado data) => json.encode(data.toJson());

class Estado {
  Estado({
    this.id,
    this.nombre,
    this.route,
  });

  String? id;
  String? nombre;
  String? route;

  factory Estado.fromJson(Map<String, dynamic> json) => Estado(
        id: json["id"] != null
            ? json["id"] is int
                ? json["id"].toString()
                : json["id"]
            : '',
        nombre: json["nombre"] ?? '',
        route: json["route"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "route": route,
      };
}
