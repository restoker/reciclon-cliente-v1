import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reciclon_client/src/models/orden.dart';
import 'package:reciclon_client/src/pages/empresa/ordenes/lista/empresa_ordenes_lista_controller.dart';
import 'package:reciclon_client/src/utils/my_colors.dart';
import 'package:reciclon_client/src/widgets/no_data_widget.dart';

class EmpresaOrdenesListaPage extends StatefulWidget {
  const EmpresaOrdenesListaPage({Key? key}) : super(key: key);

  @override
  State<EmpresaOrdenesListaPage> createState() =>
      _EmpresaOrdenesListaPageState();
}

class _EmpresaOrdenesListaPageState extends State<EmpresaOrdenesListaPage> {
  final _controller = EmpresaOrdenesListaController();

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
    return DefaultTabController(
      length: _controller.status.length,
      // initialIndex: 0,
      child: Scaffold(
        key: _controller.key,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            // leading: ,
            // actions: [
            //   _BolsaCompras(
            //     controlador: controlador,
            //   ),
            // ],
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
                      CupertinoIcons.text_alignright,
                      color: Colors.black,
                      size: 30.0,
                    ),
                  ),
                ),
              ],
            ),
            bottom: TabBar(
              // controller: ,
              indicatorColor: MyColors.colorprimario,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black45,
              isScrollable: true,
              tabs: List.generate(_controller.status.length, (i) {
                return Tab(
                  child: Text(
                    _controller.status[i],
                  ),
                );
              }),
            ),
          ),
        ),
        body: TabBarView(
          children: _controller.status.map(
            (String status) {
              return FutureBuilder(
                future: _controller.getOrdenes(status),
                // initialData: [],
                builder: (BuildContext context,
                    AsyncSnapshot<List<Orden>> snapshot) {
                  if (!snapshot.hasData) {
                    return NoDataWidget(
                      texto: 'No data',
                    );
                  }
                  if (snapshot.data!.isEmpty) {
                    return NoDataWidget(
                      texto: 'No hay Ordenes en esta categoria',
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (BuildContext context, int i) {
                      // inspect(snapshot.data![i]);
                      return GestureDetector(
                        onTap: () => _controller.goToDetalleOrdenPage(
                          snapshot.data![i],
                        ),
                        child: _CardOrden(
                          orden: snapshot.data![i],
                        ),
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
        drawer: _Drawer(controlador: _controller),
      ),
    );
  }
}

class _CardOrden extends StatelessWidget {
  const _CardOrden({
    Key? key,
    required this.orden,
  }) : super(key: key);

  final Orden orden;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      height: 160,
      width: double.infinity,
      child: Card(
        // color: Colors.green,
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Stack(
          children: [
            Positioned(
              // top: 0,
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 32,
                decoration: BoxDecoration(
                  color: MyColors.colorprimario,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
                child: Text(
                  'Orden #${orden.id}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oswald',
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              margin: EdgeInsets.only(top: 45),
              // alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // 'Fecha: ${DateTime.fromMicrosecondsSinceEpoch((orden.timestamp as int) * 1000)}',
                    'Fecha: ${DateFormat('dd/MM/yyyy, HH:mm a').format(DateTime.fromMillisecondsSinceEpoch(orden.timestamp!))}',
                    style: TextStyle(fontFamily: 'Oswald'),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Cliente: ${orden.cliente!.nombre} ${orden.cliente!.apellidos}',
                    // 'Cliente: ',
                    style: TextStyle(fontFamily: 'Oswald'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Dirección de entrega: ${orden.direccion!.direccion}',
                    style: TextStyle(fontFamily: 'Oswald'),
                    maxLines: 2,
                  ),
                ],
              ),
            )
          ],
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
  final EmpresaOrdenesListaController controlador;

  @override
  Widget build(BuildContext context) {
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
                        clipBehavior: Clip.antiAlias,
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
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                // ListTile(
                //   title: Text('Crear Categoria'),
                //   trailing: Icon(
                //     CupertinoIcons.list_bullet_below_rectangle,
                //     color: Colors.black,
                //   ),
                //   // onTap: () => controlador.goToCategoryCreate(),
                // ),
                ListTile(
                  title: Text('Crear Material de reciclaje'),
                  trailing: Icon(
                    Icons.local_pizza_outlined,
                    color: Colors.black,
                  ),
                  onTap: () => controlador.goToProductoCreate(),
                ),
                if (controlador.user!.roles!.length > 1)
                  ListTile(
                    title: Text('Crear delivery boy'),
                    trailing: Icon(
                      Icons.delivery_dining_outlined,
                      color: Colors.black,
                    ),
                    onTap: () => controlador.goToAdminDelivery(),
                  ),
                if (controlador.user!.roles!.length > 1)
                  ListTile(
                    title: Text('Seleccionar Rol'),
                    trailing: Icon(
                      CupertinoIcons.person_2_square_stack,
                      color: Colors.black,
                    ),
                    onTap: () => controlador.goToRoles(),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.43,
          ),
          Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: Text('Cerrar sesión'),
            trailing: Icon(
              CupertinoIcons.power,
              color: Colors.black,
            ),
            onTap: () => controlador.logout(),
          ),
        ],
      ),
    );
  }
}
