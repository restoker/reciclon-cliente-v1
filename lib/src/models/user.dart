import 'dart:convert';
import 'package:reciclon_client/src/models/empresa.dart';
import 'package:reciclon_client/src/models/rol.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    required this.nombre,
    required this.apellidos,
    required this.email,
    required this.telefono,
    this.password,
    this.imagen,
    this.sessionToken,
    this.roles,
    this.toList,
    this.notificationToken,
    this.empresa,
    this.saldo,
  });

  String? id;
  late String nombre;
  late String apellidos;
  late String email;
  late String telefono;
  String? password;
  String? imagen;
  double? saldo;
  String? sessionToken;
  List<Rol>? roles;
  List<User>? toList = [];
  String? notificationToken;
  Empresa? empresa;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] is int ? json["id"].toString() : json["id"],
        nombre: json["nombre"],
        apellidos: json["apellidos"],
        email: json["email"],
        telefono: json["telefono"],
        password: json["password"] ?? '',
        imagen: json["imagen"] ?? '',
        saldo: json["saldo"] is int ? json["saldo"] / 1 : json["saldo"],
        sessionToken: json["session_token"],
        roles: json["roles"] == null
            ? []
            : List<Rol>.from(
                (json["roles"] ?? []).map(
                  (model) => Rol.fromJson(model),
                ),
              ),
        notificationToken: json['notification_token'] ?? '',
        empresa:
            json["empresa"] == null ? null : Empresa.fromJson(json["empresa"]),
      );

  User.fromJsonList(List<dynamic> jsonList) {
    if (jsonList.isNotEmpty) {
      for (var element in jsonList) {
        // inspect(element);
        User orden = User.fromJson(element);
        toList!.add(orden);
      }
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "apellidos": apellidos,
        "email": email,
        "telefono": telefono,
        "saldo": saldo,
        "password": password,
        "imagen": imagen,
        "roles": roles,
        "session_token": sessionToken,
        'notification_token': notificationToken,
        "empresa": empresa
      };
}
