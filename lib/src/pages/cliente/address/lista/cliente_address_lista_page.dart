import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reciclon_client/src/models/address.dart';
import 'package:reciclon_client/src/pages/cliente/address/lista/cliente_address_lista_controller.dart';
import 'package:reciclon_client/src/utils/my_colors.dart';
import 'package:reciclon_client/src/widgets/no_data_widget.dart';

class ClienteAddressListaPage extends StatefulWidget {
  const ClienteAddressListaPage({Key? key}) : super(key: key);

  @override
  State<ClienteAddressListaPage> createState() =>
      _ClienteAddressListaPageState();
}

class _ClienteAddressListaPageState extends State<ClienteAddressListaPage> {
  final _controller = ClienteAddressListaController();

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
        title: Text('Mis Direcciones'),
        centerTitle: true,
        actions: [
          _BottonNuevaDireccion(controlador: _controller),
        ],
        backgroundColor: MyColors.colorprimario,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
              child: Text(
                'Elige donde recojer los materiales de reciclaje',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 100.0),
              child: FutureBuilder(
                future: _controller.obtenerDirecciones(),
                // initialData: InitialData,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Address>> snapshot) {
                  if (snapshot.hasData) {
                    // inspect(snapshot.data);
                    if (snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return _RadioButtonWidget(
                            controlador: _controller,
                            i: index,
                            direccion: snapshot.data![index],
                          );
                        },
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          NoDataWidget(
                              texto: 'No tienes ninguna dirección registrada.'),
                          SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () => _controller.goToNewAddress(),
                              child: Text(
                                'Nueva Dirección'.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                primary: MyColors.colorPurpura,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        NoDataWidget(texto: 'Agrega una direccion'),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () => _controller.goToNewAddress(),
                            child: Text(
                              'Nueva Dirección'.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                              primary: MyColors.colorPurpura,
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  // return CircularProgressIndicator();
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _ButtonAceptar(
        controlador: _controller,
      ),
    );
  }
}

class _RadioButtonWidget extends StatelessWidget {
  const _RadioButtonWidget({
    Key? key,
    required this.controlador,
    required this.i,
    required this.direccion,
  }) : super(key: key);

  final int i;
  final Address direccion;
  final ClienteAddressListaController controlador;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25.0).copyWith(top: 20.0),
      child: Column(
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio(
                value: i,
                groupValue: controlador.radioValue,
                onChanged: (value) {
                  controlador.handleRadioValueChange(value as int);
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(direccion.direccion),
                  Text(direccion.barrio),
                ],
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}

class _ButtonAceptar extends StatelessWidget {
  const _ButtonAceptar({
    Key? key,
    required this.controlador,
  }) : super(key: key);

  final ClienteAddressListaController controlador;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => controlador.crearOrden(),
        child: Text(
          'Pagar Orden'.toUpperCase(),
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

class _BottonNuevaDireccion extends StatelessWidget {
  const _BottonNuevaDireccion({
    Key? key,
    required this.controlador,
  }) : super(key: key);

  final ClienteAddressListaController controlador;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => controlador.goToNewAddress(),
      icon: Icon(CupertinoIcons.add),
    );
  }
}
