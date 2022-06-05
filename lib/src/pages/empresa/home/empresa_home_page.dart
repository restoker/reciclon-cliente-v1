import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reciclon_client/src/pages/empresa/home/empresa_home_controller.dart';
import 'package:reciclon_client/src/utils/my_colors.dart';

class EmpresaHomePage extends StatefulWidget {
  const EmpresaHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<EmpresaHomePage> createState() => _EmpresaHomePageState();
}

class _EmpresaHomePageState extends State<EmpresaHomePage> {
  final _controller = EmpresaHomeController();
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
      body: Center(
        child: Text('Hola gente desde empresa home page'),
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
  final EmpresaHomeController controlador;

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
                    // onTap: () => controlador.goToAdminDelivery(),
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
