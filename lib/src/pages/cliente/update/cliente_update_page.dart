import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reciclon_client/src/pages/cliente/update/cliente_update_controller.dart';
import 'package:reciclon_client/src/utils/my_colors.dart';

class ClienteUpdatePage extends StatefulWidget {
  const ClienteUpdatePage({Key? key}) : super(key: key);

  @override
  State<ClienteUpdatePage> createState() => _ClienteUpdatePageState();
}

class _ClienteUpdatePageState extends State<ClienteUpdatePage> {
  final _controller = ClienteUpdateController();
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
      body: SizedBox(
        width: double.infinity,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipPath(
                      clipper: _ProfileClipper(),
                      child: Image(
                        image: AssetImage('assets/img/bg.jpg'),
                        height: 300.0,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            height: 40.0,
                            width: 260.0,
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 24,
                                  spreadRadius: 10,
                                  color: Colors.grey.shade900.withOpacity(0.4),
                                )
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Editar Perfil',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      top: 50,
                    ),
                    Positioned(
                      top: 50.0,
                      right: 15.0,
                      child: IconButton(
                        icon: Icon(Icons.menu_outlined),
                        // onPressed: () => _scaffolKey.currentState.openDrawer(),
                        onPressed: () {},
                        iconSize: 30.0,
                        // color: Theme.of(context).primaryColor,
                        color: Colors.white,
                      ),
                    ),
                    _IconBack(),
                    Positioned(
                      child: GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('selecciona tu imagen'),
                            content: Text(
                                'Puedes tomarte o elegir una foto de tu galeria, para establecerla como perfil'),
                            actions: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.pink),
                                ),
                                onPressed: () {
                                  _controller.selectImage(ImageSource.gallery);
                                  // selectImage(ImageSource.gallery, context, refresh);
                                },
                                child: Text('galeria'),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.orange),
                                ),
                                onPressed: () {
                                  _controller.selectImage(ImageSource.camera);
                                  // selectImage(ImageSource.gallery, context, refresh);
                                },
                                child: Text('camara'),
                              ),
                            ],
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black45,
                                offset: Offset(0, 2),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: _controller.imageFile != null
                              ? CircleAvatar(
                                  backgroundImage:
                                      FileImage(_controller.imageFile!),
                                  radius: 54.0,
                                  backgroundColor: Colors.grey[200],
                                )
                              : _controller.user?.imagen != null
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          '${_controller.user!.imagen}'),
                                      radius: 54.0,
                                      backgroundColor: Colors.grey[200],
                                    )
                                  : CircleAvatar(
                                      backgroundImage:
                                          AssetImage('assets/img/avatar.png'),
                                      radius: 54.0,
                                      backgroundColor: Colors.grey[200],
                                    ),
                        ),
                      ),
                      bottom: 0.0,
                    ),
                  ],
                ),
                _FormRegister(controlador: _controller),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _ButtonRegister(controlador: _controller),
    );
  }
}

class _FormRegister extends StatefulWidget {
  final ClienteUpdateController controlador;

  const _FormRegister({
    Key? key,
    required this.controlador,
  }) : super(key: key);

  @override
  State<_FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<_FormRegister> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      // margin: EdgeInsets.only(top: 120.0),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30.0),
          _TextFieldEmail(controlador: widget.controlador),
          _TextFieldNombre(controlador: widget.controlador),
          _TextFieldApellidos(controlador: widget.controlador),
          _TextFieldTelefono(controlador: widget.controlador),
        ],
      ),
    );
  }
}

class _IconBack extends StatelessWidget {
  const _IconBack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          CupertinoIcons.back,
          color: Colors.white,
          size: 27.0,
        ),
      ),
      top: 49,
      left: 15,
    );
  }
}

class _ProfileClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.8);
    path.quadraticBezierTo(
        size.width * 0.5, size.height, size.width, size.height * 0.8);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class _TextFieldEmail extends StatelessWidget {
  const _TextFieldEmail({
    Key? key,
    required this.controlador,
  }) : super(key: key);

  final ClienteUpdateController controlador;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: TextField(
        controller: controlador.emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: 'Email',
          hintStyle: TextStyle(
            color: MyColors.colorprimariotexto,
          ),
          labelText: 'Email',
          labelStyle: TextStyle(
            color: MyColors.colorprimariotexto,
          ),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          prefixIcon: Icon(
            CupertinoIcons.mail,
            color: MyColors.colorprimario,
          ),
        ),
      ),
    );
  }
}

class _TextFieldNombre extends StatelessWidget {
  const _TextFieldNombre({
    Key? key,
    required this.controlador,
  }) : super(key: key);
  final ClienteUpdateController controlador;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: TextField(
        controller: controlador.nombreController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: 'Nombre',
          hintStyle: TextStyle(
            color: MyColors.colorprimariotexto,
          ),
          labelText: 'Nombre',
          labelStyle: TextStyle(
            color: MyColors.colorprimariotexto,
          ),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          prefixIcon: Icon(
            CupertinoIcons.person_alt_circle,
            color: MyColors.colorprimario,
          ),
        ),
      ),
    );
  }
}

class _TextFieldApellidos extends StatelessWidget {
  const _TextFieldApellidos({
    Key? key,
    required this.controlador,
  }) : super(key: key);
  final ClienteUpdateController controlador;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: TextField(
        controller: controlador.apellidoController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: 'Apellidos',
          hintStyle: TextStyle(
            color: MyColors.colorprimariotexto,
          ),
          labelText: 'Apellidos',
          labelStyle: TextStyle(
            color: MyColors.colorprimariotexto,
          ),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          prefixIcon: Icon(
            CupertinoIcons.person_alt_circle_fill,
            color: MyColors.colorprimario,
          ),
        ),
      ),
    );
  }
}

class _TextFieldTelefono extends StatelessWidget {
  const _TextFieldTelefono({
    Key? key,
    required this.controlador,
  }) : super(key: key);
  final ClienteUpdateController controlador;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: TextField(
        controller: controlador.telefonoController,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: 'Teléfono',
          hintStyle: TextStyle(
            color: MyColors.colorprimariotexto,
          ),
          labelText: 'Teléfono',
          labelStyle: TextStyle(
            color: MyColors.colorprimariotexto,
          ),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          prefixIcon: Icon(
            CupertinoIcons.phone_circle,
            color: MyColors.colorprimario,
          ),
        ),
      ),
    );
  }
}

class _ButtonRegister extends StatelessWidget {
  const _ButtonRegister({
    Key? key,
    required this.controlador,
  }) : super(key: key);
  final ClienteUpdateController controlador;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height > 720 ? 50 : 30,
      margin: EdgeInsets.symmetric(horizontal: 20.0)
          .copyWith(top: 40.0, bottom: 20.0),
      child: ElevatedButton(
        onPressed:
            controlador.isEnable ? () => controlador.update(context) : null,
        child: Text('Actualizar Perfil'.toUpperCase()),
        style: ElevatedButton.styleFrom(
            primary: MyColors.colorprimario,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: EdgeInsets.symmetric(vertical: 12.0)),
      ),
    );
  }
}
