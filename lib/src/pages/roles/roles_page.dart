import 'package:flutter/material.dart';
import 'package:reciclon_client/src/models/rol.dart';
import 'package:reciclon_client/src/pages/roles/roles_controller.dart';
import 'package:reciclon_client/src/utils/my_colors.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({Key? key}) : super(key: key);

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  final controller = RolesController();
  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    controller.init(context, refresh);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona tu rol'.toUpperCase()),
        centerTitle: true,
        backgroundColor: MyColors.colorprimario,
      ),
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
        child: ListView(
          children: controller.user != null
              ? controller.user!.roles!.map(
                  (Rol rol) {
                    return CardRol(
                      rol: rol,
                      controlador: controller,
                    );
                  },
                ).toList()
              : [],
        ),
      ),
    );
  }
}

class CardRol extends StatelessWidget {
  final Rol rol;
  final RolesController controlador;
  const CardRol({
    Key? key,
    required this.rol,
    required this.controlador,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controlador.goToPage(rol.route);
      },
      child: Column(
        children: [
          SizedBox(
            height: 100.0,
            // child: FadeInImage.assetNetwork(
            //   placeholder: 'assets/img/jar-loading.png',
            //   image: rol.image,
            // ),
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: ClipOval(
                child: FadeInImage(
                  placeholder: AssetImage('assets/img/jar-loading.gif'),
                  image: NetworkImage(rol.imagen),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 15.0),
          Text(
            rol.nombre,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
