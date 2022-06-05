import 'dart:developer';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:reciclon_client/src/models/empresa.dart';
import 'package:reciclon_client/src/pages/cliente/empresa/cliente_empresa_page.dart';
import 'package:reciclon_client/src/pages/cliente/home/cliente_home_controller.dart';
// import 'package:reciclon_client/src/pages/empresa/home/empresa_home_page.dart';
import 'package:reciclon_client/src/utils/my_colors.dart';
import 'package:reciclon_client/src/widgets/no_data_widget.dart';

class ClienteHomePage extends StatefulWidget {
  const ClienteHomePage({Key? key}) : super(key: key);

  @override
  State<ClienteHomePage> createState() => _ClienteHomePageState();
}

class _ClienteHomePageState extends State<ClienteHomePage> {
  final _controller = ClienteHomeController();
  // double _scrollOffset = 0.0;

  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _controller.init(context, refresh);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _controller.categorias.length,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        key: _controller.key,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(170),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            // title: Text('Reciclon'),
            // centerTitle: true,
            elevation: 0,
            flexibleSpace: Column(
              children: [
                SizedBox(height: 40),
                GestureDetector(
                  onTap: () => _controller.openDrawer(),
                  child: Container(
                    margin: EdgeInsets.only(left: 30.0),
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      CupertinoIcons.text_alignleft,
                      color: Colors.black,
                      size: 30.0,
                    ),
                  ),
                ),
                _SearchWidget(
                  controlador: _controller,
                )
              ],
            ),
            bottom: TabBar(
              // controller: ,
              indicatorColor: MyColors.colorprimario,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black45,
              isScrollable: true,
              tabs: List.generate(_controller.categorias.length, (i) {
                return Tab(
                  child: Text(_controller.categorias[i]),
                );
              }),
            ),
          ),
        ),
        body: TabBarView(
          children: _controller.categorias.map(
            (String categoria) {
              return FutureBuilder(
                future: _controller.getEmpresasAprobadas(categoria),
                // initialData: [],
                builder: (BuildContext context,
                    AsyncSnapshot<List<Empresa>?> snapshot) {
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
                        texto: 'No hay Ordenes en esta categoria',
                      ),
                    );
                  }
                  return GridView.builder(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0)
                            .copyWith(top: 200.0),
                    itemCount: snapshot.data?.length ?? 0,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.75,
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (BuildContext context, int i) {
                      inspect(snapshot.data![i]);
                      return _CardProduct(
                        empresa: snapshot.data![i],
                        controlador: _controller,
                      );
                    },
                    // children: List.generate(4, (index) {
                    //   return _CardProduct();
                    // }),
                  );
                },
              );
            },
          ).toList(),
        ),
        drawer: _Drawer(
          controlador: _controller,
        ),
      ),
    );
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget({
    Key? key,
    required this.controlador,
  }) : super(key: key);

  final ClienteHomeController controlador;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0).copyWith(top: 17.0),
      child: TextField(
        // onChanged: (texto) => controlador.onChangedText(texto),
        decoration: InputDecoration(
          hintText: 'Buscar',
          suffixIcon: Icon(CupertinoIcons.search),
          hintStyle: TextStyle(
            fontSize: 17.0,
            color: Colors.grey[500],
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.grey, width: 0.2),
          ),
          contentPadding: EdgeInsets.all(15.0),
        ),
      ),
    );
  }
}

class _CardProduct extends StatelessWidget {
  const _CardProduct({
    Key? key,
    required this.empresa,
    required this.controlador,
  }) : super(key: key);

  final Empresa empresa;
  final ClienteHomeController controlador;

  @override
  Widget build(BuildContext context) {
    // inspect(empresa);
    return GestureDetector(
      // onTap: () {
      //   const transitionDuration = Duration(milliseconds: 200);
      //   Navigator.of(context).push(
      //     PageRouteBuilder(
      //       transitionDuration: transitionDuration,
      //       reverseTransitionDuration: transitionDuration,
      //       pageBuilder: (_, animation, ___) {
      //         return FadeTransition(
      //           opacity: animation,
      //           child: ClienteEmpresaPage(empresa: empresa),
      //         );
      //       },
      //     ),
      //   );
      // },
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ClienteEmpresaPage(
            empresa: empresa,
          ),
        ),
      ),
      child: Container(
        height: 250.0,
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          // color: Colors.green,
          child: Stack(
            children: [
              // Positioned(
              //   right: 0,
              //   child: Container(
              //     decoration: BoxDecoration(
              //         color: Colors.red,
              //         borderRadius:
              //             BorderRadius.only(bottomLeft: Radius.circular(15.0))),
              //     child: IconButton(
              //       color: Colors.white,
              //       onPressed: () {},
              //       icon: Icon(CupertinoIcons.plus),
              //     ),
              //   ),
              // ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: 0.4,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      margin: EdgeInsets.only(left: 10.0),
                      height: 120.0,
                      width: MediaQuery.of(context).size.width * 0.45,
                      padding: EdgeInsets.all(13.0),
                      child: empresa.imagen != null
                          ? Hero(
                              tag: '${empresa.imagen}',
                              child: FadeInImage(
                                image: NetworkImage(empresa.imagen!),
                                placeholder:
                                    AssetImage('assets/img/jar-loading.gif'),
                                fit: BoxFit.cover,
                                fadeInDuration: Duration(milliseconds: 100),
                              ),
                            )
                          : FadeInImage(
                              image: AssetImage('assets/img/no-image.jpg'),
                              placeholder:
                                  AssetImage('assets/img/jar-loading.gif'),
                              fit: BoxFit.contain,
                              fadeInDuration: Duration(milliseconds: 100),
                            ),
                    ),
                    Container(
                      height: 30,
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        empresa.nombre,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Oswald',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    // Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.phone),
                        Gap(10),
                        Text(
                          empresa.telefono,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Oswald',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Positioned(
              //   bottom: 70,
              //   left: 5,
              //   child: RotatedBox(
              //     quarterTurns: 3,
              //     child: Text('Nombre Producto'),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer({
    Key? key,
    required this.controlador,
  }) : super(key: key);

  final ClienteHomeController controlador;

  @override
  Widget build(BuildContext context) {
    // inspect(controlador.user);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: MyColors.colorprimario,
            ),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${controlador.user?.nombre ?? ''} ${controlador.user?.apellidos}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  controlador.user?.email ?? '',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey[200],
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  controlador.user?.telefono ?? '',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey[200],
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    // color: Colors.red,
                  ),
                  height: 70.0,
                  child: CircleAvatar(
                    radius: 70.0,
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: ClipOval(
                        child: FadeInImage(
                          placeholder: AssetImage('assets/img/jar-loading.gif'),
                          image: controlador.user!.imagen == ''
                              ? NetworkImage(
                                  'https://www.meme-arsenal.com/memes/0dfedb042b60308a6f1180929228dbd5.jpg')
                              : NetworkImage(controlador.user!.imagen!),
                          fadeInDuration: Duration(milliseconds: 200),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Column(
            children: [
              ListTile(
                title: Text('Editar Perfil'),
                trailing: Icon(
                  CupertinoIcons.pencil_outline,
                  color: Colors.black,
                ),
                onTap: () => controlador.goToUpdatePage(context),
                // onTap: () => {},
              ),
              ListTile(
                title: Text('Mis Ordenes'),
                trailing: Icon(
                  Icons.delete_sweep_outlined,
                  color: Colors.black,
                ),
                onTap: () => controlador.goToOrdenesCliente(),
              ),
              if (controlador.user!.empresa == null ||
                  controlador.user!.empresa!.id!.isEmpty)
                ListTile(
                  title: Text('Registrar mi empresa'),
                  trailing: Icon(
                    Icons.add_business_rounded,
                    color: Colors.black,
                    size: 27.0,
                  ),
                  onTap: () => controlador.goToCrearEmpresa(),
                ),
              if (controlador.user!.empresa != null &&
                  controlador.user!.empresa!.id!.isNotEmpty &&
                  controlador.user!.empresa!.estado == 'PREAPROBADO')
                ListTile(
                  title: Text('Empresa Pendiente'),
                  trailing: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.yellow,
                            spreadRadius: 4,
                            blurRadius: 10,
                          ),
                          BoxShadow(
                            color: Colors.yellow,
                            spreadRadius: -4,
                            blurRadius: 5,
                          )
                        ]),
                    child: Icon(
                      CupertinoIcons.battery_25_percent,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () => {},
                ),
              // if (controlador.user!.empresa != null &&
              //     controlador.user!.empresa!.id!.isNotEmpty &&
              //     controlador.user!.empresa!.estado == 'APROBADO')
              //   ListTile(
              //     title: Text('Administrar mi Empresa'),
              //     trailing: Icon(
              //       Icons.business_outlined,
              //       color: Colors.black,
              //     ),
              //     onTap: () => controlador.goToCrearEmpresa(),
              //   ),
              if (controlador.user!.roles!.length > 1)
                ListTile(
                  onTap: () => controlador.goToRoles(),
                  title: Text('Seleccionar Rol'),
                  trailing: Icon(
                    CupertinoIcons.person_2_square_stack,
                    color: Colors.black,
                  ),
                ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.10),
          ListTile(
            title: Text(
              'Mi Saldo',
              style: TextStyle(
                color: Colors.black45,
              ),
            ),
            trailing: Text('.S/ ${controlador.user!.saldo}'),
            // onTap: () => {},
          ),
          Divider(
            color: Colors.grey,
          ),
          // Spacer(),
          Column(
            children: [
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: ListTile(
                  title: Text(
                    'Cerrar sesión',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  trailing: Icon(
                    CupertinoIcons.power,
                    color: Colors.red,
                  ),
                  // onTap: () => {},
                  onTap: () => controlador.logout(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
