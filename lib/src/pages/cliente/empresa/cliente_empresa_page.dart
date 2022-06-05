import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gap/gap.dart';
import 'package:reciclon_client/src/models/empresa.dart';
import 'package:reciclon_client/src/pages/cliente/empresa/cliente_empresa_controller.dart';
import 'package:reciclon_client/src/utils/my_colors.dart';

class ClienteEmpresaPage extends StatefulWidget {
  const ClienteEmpresaPage({
    Key? key,
    required this.empresa,
  }) : super(key: key);
  final Empresa empresa;

  @override
  State<ClienteEmpresaPage> createState() => _ClienteEmpresaPageState();
}

class _ClienteEmpresaPageState extends State<ClienteEmpresaPage> {
  final _controller = ClienteEmpresaController();

  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _controller.init(context, refresh, widget.empresa);
    });
  }

// tag: '${empresa.imagen}',
  @override
  Widget build(BuildContext context) {
    // inspect(widget.empresa);

    return Scaffold(
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: MyColors.colorprimario,
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(bottom: 0),
              centerTitle: true,
              collapseMode: CollapseMode.parallax,
              title: Container(
                padding: EdgeInsets.only(bottom: 20.0),
                color: Colors.black12,
                width: double.infinity,
                alignment: Alignment.bottomCenter,
                child: Text(
                  widget.empresa.nombre,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              background: FadeInImage(
                placeholder: AssetImage('assets/img/loading.gif'),
                image: NetworkImage(widget.empresa.imagen!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                margin: EdgeInsets.only(top: 20.0),
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.business_sharp),
                            Gap(5),
                            Text(
                              'Razon Social: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                fontFamily: 'Oswald',
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.empresa.razonSocial,
                          style: TextStyle(
                            fontFamily: 'Oswald',
                            fontSize: 19.0,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Gap(20.0),
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.description_outlined),
                            Gap(5),
                            Text(
                              'Descripcion: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                fontFamily: 'Oswald',
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${widget.empresa.descripcion} ${widget.empresa.descripcion} ${widget.empresa.descripcion} ${widget.empresa.descripcion} ${widget.empresa.descripcion} ${widget.empresa.descripcion} ${widget.empresa.descripcion} ${widget.empresa.descripcion} ${widget.empresa.descripcion} ${widget.empresa.descripcion} ${widget.empresa.descripcion} ${widget.empresa.descripcion} ${widget.empresa.descripcion} ${widget.empresa.descripcion}',
                          // maxLines: 8,
                          style: TextStyle(
                            fontSize: 19.0,
                            fontFamily: 'Oswald',
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Gap(15.0),
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.phone_android_outlined),
                            Gap(5),
                            Text(
                              'Teléfono: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                fontFamily: 'Oswald',
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.empresa.telefono,
                          style: TextStyle(
                            fontSize: 19.0,
                            fontFamily: 'Oswald',
                          ),
                        ),
                      ],
                    ),
                    Gap(15.0),
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined),
                            Gap(5),
                            Text(
                              'Dirección: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                fontFamily: 'Oswald',
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.empresa.direccion,
                          style: TextStyle(
                            fontSize: 19.0,
                            fontFamily: 'Oswald',
                          ),
                        ),
                      ],
                    ),
                    Gap(15.0),
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.mail_outline),
                            Gap(5),
                            Text(
                              'Email: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                fontFamily: 'Oswald',
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.empresa.email,
                          style: TextStyle(
                            fontSize: 19.0,
                            fontFamily: 'Oswald',
                          ),
                        ),
                      ],
                    ),
                    Gap(35.0),
                    Text(
                      '"Puede ver los precios que la empresa ofrese por cada producto, presionando el boton de explorar los precios: "',
                      style: TextStyle(
                        fontFamily: 'Oswald',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 20.0).copyWith(top: 40.0),
                child: ElevatedButton(
                  onPressed: () =>
                      _controller.goToDetalleProductosPage(widget.empresa.id!),
                  // onPressed: () {},
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
                          height: 50.0,
                          child: Text(
                            'Explorar los precios'.toUpperCase(),
                            style: TextStyle(
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(left: 45.0, top: 7.0),
                          height: 30.0,
                          child: Image.asset('assets/img/vision.png'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0)
                    .copyWith(top: 40.0),
                child: ElevatedButton(
                  onPressed: () =>
                      _controller.goToAddressListPage(widget.empresa.id!),
                  // onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
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
                          height: 50.0,
                          child: Text(
                            'Vender residuos'.toUpperCase(),
                            style: TextStyle(
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(left: 45.0, top: 7.0),
                          height: 30.0,
                          child: Image.asset('assets/img/buy.png'),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
