import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:reciclon_client/src/models/producto.dart';
import 'package:reciclon_client/src/pages/cliente/empresa/detalle/cliente_empresa_detalle_controller.dart';
import 'package:reciclon_client/src/utils/my_colors.dart';
import 'package:reciclon_client/src/widgets/no_data_widget.dart';

class ClienteEmpresaDetallePage extends StatefulWidget {
  const ClienteEmpresaDetallePage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  State<ClienteEmpresaDetallePage> createState() =>
      _ClienteEmpresaDetallePageState();
}

class _ClienteEmpresaDetallePageState extends State<ClienteEmpresaDetallePage> {
  final _controller = ClienteEmpresaDetalleController();
  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _controller.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos que compramos:'),
        backgroundColor: MyColors.colorprimario,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _controller.getMaterialesEmpresa(widget.id),
        builder:
            (BuildContext context, AsyncSnapshot<List<Producto>?> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              padding: EdgeInsets.only(top: 100.0),
              child: NoDataWidget(
                texto: 'No data',
              ),
            );
          }
          if (snapshot.data!.isEmpty) {
            return Container(
              padding: EdgeInsets.only(top: 100.0),
              child: NoDataWidget(
                texto: 'No hay Empresas en esta categoria',
              ),
            );
          }
          return ListView.builder(
            itemBuilder: (context, i) {
              final producto = snapshot.data![i];
              // print(producto);
              return Container(
                height: 160.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(producto.imagen1!),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black26,
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Text(
                            producto.nombre,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Text(
                            '.S/ ${producto.precio} por Kilo',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 25.0,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: snapshot.data!.length,
          );
        },
      ),
    );
  }
}
