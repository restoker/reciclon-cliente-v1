import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reciclon_client/src/pages/cliente/address/map/cliente_address_map_controller.dart';
import 'package:reciclon_client/src/utils/my_colors.dart';

class ClienteAddressMapPage extends StatefulWidget {
  const ClienteAddressMapPage({Key? key}) : super(key: key);

  @override
  State<ClienteAddressMapPage> createState() => _ClienteAddressMapPageState();
}

class _ClienteAddressMapPageState extends State<ClienteAddressMapPage> {
  final _controller = ClienteAddressMapController();
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
            onCameraMove: (position) {
              _controller.posisionInicial = position;
            },
            onCameraIdle: () async {
              await _controller.setLocationDragableInfo();
            },
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
                  // onPressed: () {},
                  onPressed: () => _controller.miPosicion(),
                  icon: Icon(Icons.my_location),
                  label: Text('Yo'),
                ),
              ),
            ),
          ),
          _MiMarker(
            controlador: _controller,
          ),
          _BotonSeleccionarDireccion(
            controlador: _controller,
          ),
        ],
      ),
    );
  }
}

class _MiMarker extends StatelessWidget {
  const _MiMarker({
    Key? key,
    required this.controlador,
  }) : super(key: key);

  final ClienteAddressMapController controlador;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            // width: 140,
            height: 40,
            constraints: BoxConstraints(maxWidth: 250.0),
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            // alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AutoSizeText(
                  controlador.addressName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 10,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                )
              ],
              border: Border.all(width: 1, color: Colors.white),
            ),
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                      )
                    ],
                    border: Border.all(width: 1, color: Colors.white)),
                // child: ,
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: Colors.white)),
                // child: ,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _BotonSeleccionarDireccion extends StatelessWidget {
  const _BotonSeleccionarDireccion({
    Key? key,
    required this.controlador,
  }) : super(key: key);
  final ClienteAddressMapController controlador;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 50,
        ),
        child: Container(
          // color: MyColors.colorprimario2,
          alignment: Alignment.center,
          // width: double.infinity,
          child: ElevatedButton(
            onPressed: () => controlador.selectRefPoint(),
            child: Text(
              'Seleccionar Este punto'.toUpperCase(),
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
        ),
      ),
    );
  }
}
