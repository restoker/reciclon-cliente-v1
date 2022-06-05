import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:reciclon_client/src/models/orden.dart';
import 'package:reciclon_client/src/utils/my_colors.dart';
import 'package:reciclon_client/src/utils/relative_time_util.dart';

class ClienteOrdenDetallePagadoPage extends StatefulWidget {
  const ClienteOrdenDetallePagadoPage({
    Key? key,
    required this.orden,
  }) : super(key: key);
  final Orden orden;

  @override
  State<ClienteOrdenDetallePagadoPage> createState() =>
      _ClienteOrdenDetallePagadoPageState();
}

class _ClienteOrdenDetallePagadoPageState
    extends State<ClienteOrdenDetallePagadoPage> {
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
            Container(
              // padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Material(
                elevation: 2.0,
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Estamos asignando a alguien para recojer tus residuos',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: MyColors.colorprimariotexto,
                            fontSize: 17.0,
                            fontFamily: 'Oswald',
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          'Espere por favor...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: MyColors.colorprimariotexto,
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
                        //   child: Align(
                        //     alignment: Alignment.center,
                        //     child: FadeInImage(
                        //       placeholder:
                        //           AssetImage('assets/img/jar-loading.gif'),
                        //       image: AssetImage('assets/img/cooking.gif'),
                        //       fit: BoxFit.contain,
                        //       height: 55,
                        //       width: 55,
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  'Mi nombre: ',
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
                  '${widget.orden.status}',
                  // 'total',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                    fontFamily: 'Oswald',
                  ),
                ),
              ],
            ),
            SizedBox(height: 2),
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
        top: 50.0,
        bottom: MediaQuery.of(context).size.height * 0.2,
      ),
      child: Lottie.asset(
        'assets/json/working.json',
        width: double.infinity,
        height: 185.0,
        fit: BoxFit.cover,
        // repeat: false,
      ),
    );
  }
}
