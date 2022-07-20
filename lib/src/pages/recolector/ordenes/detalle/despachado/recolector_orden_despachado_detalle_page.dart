import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:reciclon_client/src/models/orden.dart';
import 'package:reciclon_client/src/pages/recolector/ordenes/detalle/despachado/recolector_orden_despachado_detalle_controller.dart';
import 'package:reciclon_client/src/utils/my_colors.dart';
import 'package:reciclon_client/src/utils/relative_time_util.dart';
// import 'package:reciclon_client/src/widgets/no_data_widget.dart';

class RecolectorOrdenDespachadoDetallePage extends StatefulWidget {
  const RecolectorOrdenDespachadoDetallePage({
    Key? key,
    required this.orden,
  }) : super(key: key);

  final Orden orden;

  @override
  State<RecolectorOrdenDespachadoDetallePage> createState() =>
      _RecolectorOrdenDespachadoDetallePageState();
}

class _RecolectorOrdenDespachadoDetallePageState
    extends State<RecolectorOrdenDespachadoDetallePage> {
  final _controller = RecolectorOrdenDespachadoDetalleController();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.colorprimario,
        title: Text('Orden #${widget.orden.id}'),
        centerTitle: true,
      ),
      body: Center(
        child: _ImageBannerLottie(),
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
            Material(
              elevation: 2.0,
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Detalle orden:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MyColors.colorprimario2,
                        fontSize: 17.0,
                        fontFamily: 'Oswald',
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    // Container(
                    //   // color: Colors.purple,
                    //   // alignment: Alignment.center,
                    //   width: double.infinity,
                    //   padding: EdgeInsets.symmetric(vertical: 5.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       FadeInImage(
                    //         placeholder:
                    //             AssetImage('assets/img/jar-loading.gif'),
                    //         image: NetworkImage(widget.orden.delivery!.image),
                    //         fit: BoxFit.cover,
                    //         height: 45,
                    //         width: 45,
                    //       ),
                    //       SizedBox(width: 10),
                    //       Text(
                    //         '${widget.orden.delivery!.name} ${widget.orden.delivery!.lastname}',
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
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
                  'Status:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                    fontFamily: 'Oswald',
                  ),
                ),
                Text(
                  '${widget.orden.status}',
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
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('⚠️ Confirmar orden'),
                    content: Text(
                        '❗ Una vez aceptada la orden, no podra cambiarse 🙀'),
                    actions: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.pink),
                        ),
                        onPressed: () => _controller.actualizarOrdenAEncamino(),
                        child: Text('Aceptar 🚀'),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.orange),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text('Salir ☔'),
                      ),
                    ],
                  ),
                ),
                // onPressed: () => _controller
                //     .actualizarOrdenAEncamino(widget.orden.recolector!.id!),
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
                          'Iniciar Entrega'.toUpperCase(),
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
                          CupertinoIcons.car_detailed,
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
        // top: 10.0,
        bottom: MediaQuery.of(context).size.height * 0.2,
      ),
      child: Lottie.asset(
        'assets/json/driving.json',
        width: 280.0,
        height: 150.0,
        fit: BoxFit.cover,
        // repeat: false,
      ),
    );
  }
}
