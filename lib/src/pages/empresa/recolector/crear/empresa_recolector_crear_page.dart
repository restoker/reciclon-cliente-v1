import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/pages/empresa/recolector/crear/empresa_recolector_crear_controller.dart';
import 'package:reciclon_client/src/utils/my_colors.dart';
import 'package:reciclon_client/src/widgets/no_data_widget.dart';

class EmpresaRecolectorCrearPage extends StatefulWidget {
  const EmpresaRecolectorCrearPage({Key? key}) : super(key: key);

  @override
  State<EmpresaRecolectorCrearPage> createState() =>
      _EmpresaRecolectorCrearPageState();
}

class _EmpresaRecolectorCrearPageState
    extends State<EmpresaRecolectorCrearPage> {
  final _controller = EmpresaRecolectorCrearController();

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
      key: _controller.key,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: MyColors.colorprimario,
          // backgroundColor: Colors.white,
          actions: [
            GestureDetector(
              onTap: () => _controller.openDrawer(context),
              child: Padding(
                padding: EdgeInsets.only(right: 30.0),
                child: Icon(
                  CupertinoIcons.text_alignleft,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
            ),
          ],
          flexibleSpace: Container(
            // decoration: const BoxDecoration(
            //   gradient: LinearGradient(
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //     // stops: [0.5, 0.6],
            //     colors: [Color(0xff141E30), Color(0xff243B55)],
            //   ),
            // ),
            child: Column(
              children: [
                SizedBox(height: 40),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(left: 30.0),
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      CupertinoIcons.back,
                      color: Colors.white,
                      size: 25.0,
                    ),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
                SizedBox(height: 5),
                _SearchWidget(
                  controlador: _controller,
                )
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _controller.getUsers(),
        // initialData: InitialData,
        builder: (BuildContext context, AsyncSnapshot<List<User>?> snapshot) {
          if (!snapshot.hasData) {
            return NoDataWidget(
              texto: 'No data',
            );
          }
          if (snapshot.data!.isEmpty) {
            return NoDataWidget(
              texto: 'No hay productos en esta categoria',
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (_, int i) {
              final User usuario = snapshot.data![i];
              // inspect(snapshot.data![0]);
              return Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Dismissible(
                  key: Key('${usuario.id}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Color(0xffA8A7A7),
                            // Color(0xffCC527A),
                            // Color(0xffE8175D),
                            Color(0xff474747),
                            Color(0xff363636),
                          ],
                          // stops: [0.4, 0.6],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Asignar rol de Repartidor',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 20.0),
                          Icon(
                            Icons.delivery_dining_outlined,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                  confirmDismiss: (_) {
                    return showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: Text('Asignar rol de repartidor'),
                            content: Text(
                                'Una vez asignado el rol de repartidor el usuario no aparecera en esta lista'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  bool respuesta =
                                      await _controller.crearUsuarioDelivery(
                                          usuario.id as String);
                                  Navigator.pop(context, respuesta);
                                  if (respuesta == true) {
                                    refresh();
                                  }
                                },
                                child: Text('Confirmar'),
                              ),
                            ],
                          );
                        });
                  },
                  child: ListTile(
                    leading: usuario.imagen != null
                        ? ClipOval(
                            child: Image.network(
                              usuario.imagen!,
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset('assets/img/profile.jpg'),
                    title: Text('${usuario.nombre} ${usuario.apellidos}'),
                    trailing: Icon(
                      CupertinoIcons.arrow_left_to_line,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      drawer: _Drawer(controlador: _controller),
    );
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget({
    Key? key,
    required this.controlador,
  }) : super(key: key);

  final EmpresaRecolectorCrearController controlador;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0).copyWith(top: 17.0),
      child: TextField(
        onChanged: (texto) => controlador.onChangedText(texto),
        decoration: InputDecoration(
          hintText: 'Buscar Usuario...',
          suffixIcon: Icon(CupertinoIcons.search, color: Colors.white),
          hintStyle: TextStyle(
            fontSize: 17.0,
            color: Colors.grey[100],
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.white),
            // borderSide: BorderSide(color: Colors.grey.withOpacity(0.9)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.grey, width: 0.2),
          ),
          contentPadding: EdgeInsets.all(15.0),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer({
    Key? key,
    required this.controlador,
  }) : super(key: key);
  final EmpresaRecolectorCrearController controlador;

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
                // Container(
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(40.0),
                //     color: Colors.red,
                //   ),
                //   height: 70.0,
                //   child: ClipOval(
                //     child: FadeInImage(
                //       placeholder: AssetImage('assets/img/jar-loading.gif'),
                //       image: AssetImage('assets/img/profile.jpg'),
                //       fadeInDuration: Duration(milliseconds: 200),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                ListTile(
                  title: Text('Crear Categoria'),
                  trailing: Icon(
                    CupertinoIcons.list_bullet_below_rectangle,
                    color: Colors.black,
                  ),
                  onTap: () => controlador.goToCategoryCreate(),
                ),
                ListTile(
                  title: Text('Crear producto'),
                  trailing: Icon(
                    Icons.local_pizza_outlined,
                    color: Colors.black,
                  ),
                  onTap: () => controlador.goToProductoCreate(context),
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
                    onTap: () => controlador.goToRoles(context),
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
            onTap: () => controlador.logout(context),
          ),
        ],
      ),
    );
  }
}
