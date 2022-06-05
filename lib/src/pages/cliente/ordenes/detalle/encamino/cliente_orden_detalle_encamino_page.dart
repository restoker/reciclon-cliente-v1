import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reciclon_client/src/models/orden.dart';
import 'package:reciclon_client/src/pages/cliente/ordenes/detalle/encamino/cliente_orden_detalle_encamino_controller.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ClienteOrdenDetalleEncaminoPage extends StatefulWidget {
  const ClienteOrdenDetalleEncaminoPage({
    Key? key,
    required this.orden,
  }) : super(key: key);
  final Orden orden;

  @override
  State<ClienteOrdenDetalleEncaminoPage> createState() =>
      _ClienteOrdenDetalleEncaminoPageState();
}

class _ClienteOrdenDetalleEncaminoPageState
    extends State<ClienteOrdenDetalleEncaminoPage> {
  final _controller = ClienteOrdenDetalleEncaminoController();

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
    return Scaffold(
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
            //   controlador.posisionInicial = position;
            // },
            // onCameraIdle: () async {
            //   // await controlador.setLocationDragableInfo();
            // },
          ),
          if (_controller.esInstanciado)
            SlidingUpPanel(
              color: Color(0xff1A2151),
              backdropEnabled: true,
              borderRadius: BorderRadius.vertical(top: Radius.circular(36.0)),
              minHeight: 30.0,
              maxHeight: MediaQuery.of(context).size.height * 0.35,
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
                                  child: widget.orden.recolector?.imagen != null
                                      ? FadeInImage(
                                          image: NetworkImage(_controller
                                              .orden.recolector!.imagen!),
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
                                    '${widget.orden.recolector!.nombre} ${widget.orden.recolector!.apellidos}',
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
