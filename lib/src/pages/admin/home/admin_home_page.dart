import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reciclon_client/src/pages/admin/home/admin_home_controller.dart';
import 'package:reciclon_client/src/utils/my_colors.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final _controller = AdminHomeController();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: _controller.goToAdminEmpresas,
              child: Text('Administrar empresas'),
            )
          ],
        ),
      ),
      drawer: _Drawer(controlador: _controller),
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer({
    Key? key,
    required this.controlador,
  }) : super(key: key);

  final AdminHomeController controlador;

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
              // ListTile(
              //   title: Text('Mis pedidos'),
              //   trailing: Icon(
              //     CupertinoIcons.shopping_cart,
              //     color: Colors.black,
              //   ),
              //   onTap: () => {},
              //   // onTap: () => controlador.goToPedidos(context),
              // ),
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
