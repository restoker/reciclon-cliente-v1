import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:reciclon_client/src/models/orden.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/pages/empresa/ordenes/detalle/pagado/empresa_detalle_pagado_controller.dart';
import 'package:reciclon_client/src/utils/my_colors.dart';
import 'package:reciclon_client/src/utils/relative_time_util.dart';
// import 'package:reciclon_client/src/widgets/no_data_widget.dart';

class EmpresaOrdenesDetallePagadoPage extends StatefulWidget {
  const EmpresaOrdenesDetallePagadoPage({
    Key? key,
    required this.orden,
  }) : super(key: key);

  final Orden orden;

  @override
  State<EmpresaOrdenesDetallePagadoPage> createState() =>
      _EmpresaOrdenesDetallePagadoPageState();
}

class _EmpresaOrdenesDetallePagadoPageState
    extends State<EmpresaOrdenesDetallePagadoPage> {
  final _controller = EmpresaDetallePagadoController();
  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _controller.init(context, refresh, widget.orden);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    inspect(widget.orden);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.colorprimario,
        title: Text('Orden #${widget.orden.id}'),
        centerTitle: true,
      ),
      body: Center(
        child: Stack(
          children: [
            _ImageBannerLottie(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.38,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Divider(
              indent: 5.0,
              endIndent: 5.0,
              color: Colors.grey,
            ),
            Container(
              // padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Material(
                elevation: 2.0,
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Asignar Recolector',
                            style: TextStyle(
                              color: MyColors.colorprimario,
                              fontSize: 17.0,
                              fontFamily: 'Oswald',
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0)
                            .copyWith(top: 5.0),
                        child: DropdownButton(
                          underline: Container(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.arrow_drop_down_circle_sharp,
                              color: MyColors.colorprimario,
                              size: 26,
                            ),
                          ),
                          items: _dropDownItems(_controller.repartidores),
                          value: _controller.idRepartidor,
                          onChanged: (opcion) {
                            setState(() {
                              // print('recolector seleccionado: $opcion');
                              _controller.idRepartidor = opcion.toString();
                            });
                          },
                          elevation: 3,
                          isExpanded: true,
                          hint: Text(
                            'Recolector',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                              fontFamily: 'Oswald',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  'Cliente: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    fontFamily: 'Oswald',
                  ),
                ),
                Expanded(
                  child: Text(
                    '${widget.orden.cliente!.nombre} ${widget.orden.cliente!.apellidos}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Oswald',
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Entregar en: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    fontFamily: 'Oswald',
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.orden.direccion!.direccion,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Oswald',
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Fecha pedido: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    fontFamily: 'Oswald',
                  ),
                ),
                Text(
                  // DateFormat('dd/MM/yyyy, HH:mm a').format(
                  //   DateTime.fromMillisecondsSinceEpoch(
                  //     widget.orden.timestamp!,
                  //   ),
                  // ),
                  RelativeTimeUtil.getRelativeTime(widget.orden.timestamp!),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Oswald',
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Estado:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                    fontFamily: 'Oswald',
                  ),
                ),
                Text(
                  ' ${widget.orden.status}',
                  // 'total',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                    fontFamily: 'Oswald',
                  ),
                ),
              ],
            ),
            SizedBox(height: 2),
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                // onPressed: () {},
                onPressed: _controller.idRepartidor != null
                    ? () => _controller.actualizarOrdenADespachado()
                    : null,
                style: ElevatedButton.styleFrom(
                  primary: MyColors.colorprimario,
                  padding: EdgeInsets.symmetric(vertical: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment.center,
                        height: 45.0,
                        child: Text(
                          'Despachar Orden'.toUpperCase(),
                          style: TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Oswald',
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(left: 65.0, top: 5.0),
                        height: 30.0,
                        child: Icon(
                          CupertinoIcons.share_solid,
                          size: 30.0,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ImageBannerLottie extends StatelessWidget {
  const _ImageBannerLottie({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //     // borderRadius: BorderRadius.circular(25.0),
      //     ),
      margin: EdgeInsets.only(
        top: 10.0,
        bottom: MediaQuery.of(context).size.height * 0.09,
      ),
      child: Lottie.asset(
        'assets/json/camiones.json',
        width: 280.0,
        height: 150.0,
        fit: BoxFit.cover,
        // repeat: false,
      ),
    );
  }
}

List<DropdownMenuItem<String>> _dropDownItems(List<User>? repartidores) {
  List<DropdownMenuItem<String>> lista = [];
  if (repartidores!.isEmpty) {
    return [];
  }
  for (User repartidor in repartidores) {
    // inspect(repartidor);
    lista.add(DropdownMenuItem(
      child: Row(
        children: [
          FadeInImage(
            placeholder: AssetImage('assets/img/jar-loading.gif'),
            image: NetworkImage(repartidor.imagen!),
            fit: BoxFit.cover,
            height: 45,
            width: 45,
          ),
          SizedBox(width: 10),
          Text('${repartidor.nombre} ${repartidor.apellidos}'),
        ],
      ),
      value: repartidor.id,
    ));
  }
  return lista;
}
