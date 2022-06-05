import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reciclon_client/src/pages/cliente/address/crear/cliente_address_crear_controller.dart';
import 'package:reciclon_client/src/utils/my_colors.dart';

class ClienteAddressCrearPage extends StatefulWidget {
  const ClienteAddressCrearPage({Key? key}) : super(key: key);

  @override
  State<ClienteAddressCrearPage> createState() =>
      _ClienteAddressCrearPageState();
}

class _ClienteAddressCrearPageState extends State<ClienteAddressCrearPage> {
  final _controller = ClienteAddressCrearController();

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
        title: Text('Nueva dirección'),
        backgroundColor: MyColors.colorprimario,
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
                child: Text(
                  'Completa los datos',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
                child: TextField(
                  controller: _controller.direccion,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Dirección',
                    suffixIcon: Icon(
                      CupertinoIcons.location,
                      color: MyColors.colorprimario,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
                child: TextField(
                  controller: _controller.barrio,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Barrio',
                    suffixIcon: Icon(
                      Icons.location_city_rounded,
                      color: MyColors.colorprimario,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
                child: TextField(
                  controller: _controller.especificacionText,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText:
                        'p.e: cuarto piso, puerta roja, al costado de la farmacia...',
                    labelText: 'especificaciones',
                    suffixIcon: Icon(
                      Icons.location_searching_rounded,
                      color: MyColors.colorprimario,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
                child: TextField(
                  controller: _controller.refPointController,
                  onTap: () => _controller.goToMap(),
                  autofocus: false,
                  focusNode: AlwaysDisableFocusNode(),
                  decoration: InputDecoration(
                    labelText: 'Punto de Referencia',
                    suffixIcon: Icon(
                      CupertinoIcons.map,
                      color: MyColors.colorprimario,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _ButtonCrearDireccion(
        controlador: _controller,
      ),
    );
  }
}

class _ButtonCrearDireccion extends StatelessWidget {
  const _ButtonCrearDireccion({
    Key? key,
    required this.controlador,
  }) : super(key: key);

  final ClienteAddressCrearController controlador;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => controlador.crearDireccion(),
        child: Text(
          'Crear Dirección'.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          primary: MyColors.colorprimario,
        ),
      ),
    );
  }
}

class AlwaysDisableFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
