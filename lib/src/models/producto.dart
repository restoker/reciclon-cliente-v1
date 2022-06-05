import 'dart:convert';

Producto productoFromJson(String str) => Producto.fromJson(json.decode(str));

String productoToJson(Producto data) => json.encode(data.toJson());

class Producto {
  Producto({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    this.imagen1,
    this.imagen2,
    this.imagen3,
    required this.idCategoria,
    required this.idEmpresa,
    this.peso,
    this.toList,
  });

  String? id;
  late String nombre;
  late String descripcion;
  late double precio;
  String? imagen1;
  String? imagen2;
  String? imagen3;
  late int idCategoria;
  late int idEmpresa;
  int? peso;
  List<Producto>? toList = [];

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        id: json["id"] is int ? json["id"].toString() : json["id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        precio: json["precio"].runtimeType == String
            ? double.parse(json["precio"])
            : json["precio"].runtimeType == int
                ? json["precio"] + 0.0
                : json["precio"],
        // precio: json["precio"] is String
        //     ? double.parse(json["precio"])
        //     : isInteger(json["precio"])
        //         ? json["precio"].toDouble()
        //         : json["precio"],
        imagen1: json["imagen1"],
        imagen2: json["imagen2"],
        imagen3: json["imagen3"],
        idCategoria: json["id_categoria"].runtimeType == String
            ? int.parse(json["id_categoria"])
            : json["id_categoria"],
        idEmpresa: json["id_empresa"].runtimeType == String
            ? int.parse(json["id_empresa"])
            : json["id_empresa"],
        peso: json["peso"] == null ? 0 : json["peso"],
      );

  Producto.fromJsonList(List<dynamic> jsonList) {
    if (jsonList.isNotEmpty) {
      for (var element in jsonList) {
        Producto producto = Producto.fromJson(element);
        toList!.add(producto);
      }
    } else {
      toList = [];
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "descripcion": descripcion,
        "precio": precio,
        "imagen1": imagen1,
        "imagen2": imagen2,
        "imagen3": imagen3,
        "id_categoria": idCategoria,
        "id_empresa": idEmpresa,
        "peso": peso,
      };

  static bool isInteger(int value) =>
      value is int || value == value.roundToDouble();
}
