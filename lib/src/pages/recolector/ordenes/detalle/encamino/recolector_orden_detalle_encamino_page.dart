import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reciclon_client/src/models/orden.dart';
import 'package:reciclon_client/src/pages/recolector/ordenes/detalle/encamino/recolector_orden_detalle_encamino_controller.dart';
import 'package:reciclon_client/src/utils/my_colors.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RecolectorOrdenDetalleEncaminoPage extends StatefulWidget {
  const RecolectorOrdenDetalleEncaminoPage({
    Key? key,
    required this.orden,
  }) : super(key: key);
  final Orden orden;

  @override
  State<RecolectorOrdenDetalleEncaminoPage> createState() =>
      _RecolectorOrdenDetalleEncaminoPageState();
}

class _RecolectorOrdenDetalleEncaminoPageState
    extends State<RecolectorOrdenDetalleEncaminoPage> {
  final _controller = RecolectorOrdenDetalleEncaminoController();

  void refresh() {
    if (!mounted) return;
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        // Navigator.popUntil(context, (route) => false);
        return false;
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text('Mapa'),
        //   backgroundColor: MyColors.colorprimario,
        // ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _controller.posisionInicial,
              onMapCreated: (GoogleMapController controller) {
                _controller.onMapCreated(controller);
              },
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              markers: Set<Marker>.of(_controller.markers.values),
              zoomControlsEnabled: false, // quitar botones del zoom
              // onCameraMove: (position) {
              //   _controller.posisionInicial = position;
              // },
              // onCameraIdle: () async {
              //   // await controlador.setLocationDragableInfo();
              // },
            ),
            Positioned(
              top: 25,
              right: 20,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 20,
                ),
                child: Container(
                  // color: Colors.red,
                  // alignment: Alignment.topRight,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      primary: Colors.black,
                    ),
                    onPressed: () => _controller.miPosicion(),
                    icon: Icon(Icons.my_location),
                    label: Text('Yo'),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 35,
              left: 20,
              child: GestureDetector(
                onTap: () => _controller.launchGoogleMaps(),
                child: Container(
                  child: Image.asset(
                    'assets/img/google_maps.png',
                    height: 40,
                    width: 40,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 90,
              left: 17,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  child: Image.asset(
                    'assets/img/waze.png',
                    height: 40,
                    width: 40,
                  ),
                ),
              ),
            ),
            if (_controller.esInstanciado)
              SlidingUpPanel(
                color: Color(0xff1A2151),
                backdropEnabled: true,
                borderRadius: BorderRadius.vertical(top: Radius.circular(36.0)),
                minHeight: 35.0,
                maxHeight: MediaQuery.of(context).size.height * 0.55,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
                panel: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 12.0,
                          bottom: 16.0,
                        ),
                        child: Container(
                          width: 42.0,
                          height: 5.0,
                          decoration: BoxDecoration(
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                      child: Container(
                        // decoration: BoxDecoration(color: Colors.red),
                        child: Column(
                          children: [
                            _ListtileItem(
                              titulo: widget.orden.direccion!.barrio,
                              subtitulo: 'Barrio',
                              icono: Icons.my_location_outlined,
                            ),
                            _ListtileItem(
                              titulo: widget.orden.direccion!.direccion,
                              subtitulo: 'Dirección',
                              icono: CupertinoIcons.location,
                            ),
                            Divider(
                              color: Colors.grey[400],
                              indent: 30,
                              endIndent: 30,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 30),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 50.0,
                                    width: 50.0,
                                    child: widget.orden.cliente?.imagen != null
                                        ? FadeInImage(
                                            image: NetworkImage(_controller
                                                .orden.cliente!.imagen!),
                                            placeholder: AssetImage(
                                                'assets/img/jar-loading.gif'),
                                            fit: BoxFit.contain,
                                            fadeInDuration:
                                                Duration(milliseconds: 100),
                                          )
                                        : FadeInImage(
                                            image: AssetImage(
                                                'assets/img/no-image.jpg'),
                                            placeholder: AssetImage(
                                                'assets/img/jar-loading.gif'),
                                            fit: BoxFit.contain,
                                            fadeInDuration:
                                                Duration(milliseconds: 100),
                                          ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      '${widget.orden.cliente!.nombre} ${widget.orden.cliente!.apellidos}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.0,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: Colors.grey[300],
                                    ),
                                    child: IconButton(
                                      onPressed: () => _controller.call(),
                                      icon: Icon(CupertinoIcons.phone),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 30),
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () =>
                                    _controller.actualizarOrdenAEntregado(),
                                child: Text(
                                  'Entregar productos'.toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  primary: MyColors.colorprimario2,
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
          ],
        ),
        // bottomNavigationBar: ,
      ),
    );
  }
}

class _ListtileItem extends StatelessWidget {
  const _ListtileItem({
    Key? key,
    required this.titulo,
    required this.subtitulo,
    required this.icono,
  }) : super(key: key);

  final String titulo;
  final String subtitulo;
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        titulo,
        style: TextStyle(
          fontSize: 15,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        subtitulo,
        style: TextStyle(
          color: Colors.grey[500],
        ),
      ),
      trailing: Icon(
        icono,
        color: Colors.grey[500],
      ),
    );
  }
}
