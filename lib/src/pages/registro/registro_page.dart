import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reciclon_client/src/pages/registro/registro_controller.dart';
import 'package:reciclon_client/src/utils/my_colors.dart';

class RegistroPage extends StatefulWidget {
  const RegistroPage({Key? key}) : super(key: key);

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final _controller = RegistroController();
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
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/img/bg4.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              child: _CircleRegister(),
              top: -80.0,
              left: -90.0,
            ),
            Positioned(
              child: _TextRegister(),
              top: 61,
              left: 32,
            ),
            _IconBack(),
            _FormRegister(controlador: _controller),
          ],
        ),
      ),
    );
  }
}

class _FormRegister extends StatefulWidget {
  const _FormRegister({
    Key? key,
    required this.controlador,
  }) : super(key: key);

  final RegistroController controlador;

  @override
  State<_FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<_FormRegister> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 120.0),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                // onTap: () => controlador.seleccionarFotoPerfil(context),
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
                              MaterialStateProperty.all<Color>(Colors.pink),
                        ),
                        onPressed: () {
                          widget.controlador.selectImage(ImageSource.gallery);
                          // selectImage(ImageSource.gallery, context, refresh);
                        },
                        child: Text('galeria'),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.orange),
                        ),
                        onPressed: () {
                          widget.controlador.selectImage(ImageSource.camera);
                          // selectImage(ImageSource.gallery, context, refresh);
                        },
                        child: Text('camara'),
                      ),
                    ],
                  ),
                ),
                child: widget.controlador.imageFile != null
                    ? CircleAvatar(
                        backgroundImage:
                            FileImage(widget.controlador.imageFile!),
                        radius: 54.0,
                        backgroundColor: Colors.grey[200],
                      )
                    : CircleAvatar(
                        backgroundImage: AssetImage('assets/img/avatar.png'),
                        radius: 54.0,
                        backgroundColor: Colors.grey[200],
                      ),
              ),
              SizedBox(height: 40.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: _TextFieldEmail(controlador: widget.controlador)),
                ),
              ),
              SizedBox(height: 10.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: _TextFieldNombre(controlador: widget.controlador)),
                ),
              ),
              SizedBox(height: 10.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child:
                          _TextFieldApellidos(controlador: widget.controlador)),
                ),
              ),
              SizedBox(height: 10.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child:
                          _TextFieldTelefono(controlador: widget.controlador)),
                ),
              ),
              SizedBox(height: 10.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child:
                          _TextFieldPassword(controlador: widget.controlador)),
                ),
              ),
              SizedBox(height: 10.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child:
                          _TextFieldConfirmar(controlador: widget.controlador)),
                ),
              ),
              SizedBox(height: 10.0),
              _ButtonRegister(controlador: widget.controlador),
              _TextHaveAcount(controlador: widget.controlador),
            ],
          ),
        ),
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
        onPressed: () => Navigator.pop(context, 'login'),
        icon: Icon(
          CupertinoIcons.back,
          color: Colors.white,
        ),
      ),
      top: 49,
      left: -8,
    );
  }
}

class _CircleRegister extends StatelessWidget {
  const _CircleRegister({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240.0,
      height: 230.0,
      decoration: BoxDecoration(
        // color: MyColors.colorprimario,
        borderRadius: BorderRadius.circular(100.0),
        gradient: LinearGradient(
          begin: Alignment(-0.95, 0.0),
          end: Alignment(1.0, 0.0),
          colors: const [Color(0xff00C9A7), Color(0xff0088C2)],
        ),
      ),
      child: Text('Hola'),
    );
  }
}

class _TextRegister extends StatelessWidget {
  const _TextRegister({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Registro'.toUpperCase(),
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 22.0,
        fontFamily: 'Oswald',
      ),
    );
  }
}

class _TextFieldEmail extends StatelessWidget {
  const _TextFieldEmail({
    Key? key,
    required this.controlador,
  }) : super(key: key);

  final RegistroController controlador;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: TextField(
        style: TextStyle(color: Colors.white),
        controller: controlador.emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: 'Email',
          hintStyle: TextStyle(
            color: MyColors.colorprimario,
          ),
          labelText: 'Email',
          labelStyle: TextStyle(
            color: MyColors.colorprimario,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0),
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
  final RegistroController controlador;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: TextField(
        style: TextStyle(color: Colors.white),
        controller: controlador.nombreController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: 'Nombre',
          hintStyle: TextStyle(
            color: MyColors.colorprimario,
          ),
          labelText: 'Nombre',
          labelStyle: TextStyle(
            color: MyColors.colorprimario,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0),
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
  final RegistroController controlador;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: TextField(
        style: TextStyle(color: Colors.white),
        controller: controlador.apellidoController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: 'Apellidos',
          hintStyle: TextStyle(
            color: MyColors.colorprimario,
          ),
          labelText: 'Apellidos',
          labelStyle: TextStyle(
            color: MyColors.colorprimario,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0),
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
  final RegistroController controlador;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: TextField(
        style: TextStyle(color: Colors.white),
        controller: controlador.telefonoController,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: 'Teléfono',
          hintStyle: TextStyle(
            color: MyColors.colorprimario,
          ),
          labelText: 'Teléfono',
          labelStyle: TextStyle(
            color: MyColors.colorprimario,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0),
          prefixIcon: Icon(
            CupertinoIcons.phone_circle,
            color: MyColors.colorprimario,
          ),
        ),
      ),
    );
  }
}

class _TextFieldPassword extends StatelessWidget {
  const _TextFieldPassword({
    Key? key,
    required this.controlador,
  }) : super(key: key);
  final RegistroController controlador;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(6.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: TextField(
        style: TextStyle(color: Colors.white),
        controller: controlador.passwordController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: TextStyle(
            color: MyColors.colorprimario,
          ),
          labelText: 'Password',
          labelStyle: TextStyle(
            color: MyColors.colorprimario,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0),
          prefixIcon: Icon(
            CupertinoIcons.padlock_solid,
            color: MyColors.colorprimario,
          ),
          suffixIcon: controlador.isBlind
              ? IconButton(
                  onPressed: () => controlador.mostrarPassword(),
                  icon: Icon(
                    CupertinoIcons.eye,
                    color: MyColors.colorprimario,
                  ),
                )
              : IconButton(
                  onPressed: () => controlador.mostrarPassword(),
                  icon: Icon(
                    CupertinoIcons.eye_slash,
                    color: MyColors.colorprimario,
                  ),
                ),
        ),
        obscureText: controlador.isBlind ? true : false,
      ),
    );
  }
}

class _TextFieldConfirmar extends StatelessWidget {
  const _TextFieldConfirmar({
    Key? key,
    required this.controlador,
  }) : super(key: key);
  final RegistroController controlador;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: TextField(
        style: TextStyle(color: Colors.white),
        controller: controlador.confirmarController,
        textInputAction: TextInputAction.send,
        onSubmitted: (texto) => controlador.registro(),
        decoration: InputDecoration(
          hintText: 'Confirmar password',
          hintStyle: TextStyle(
            color: MyColors.colorprimario,
          ),
          labelText: 'Confirmar password',
          labelStyle: TextStyle(
            color: MyColors.colorprimario,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0),
          prefixIcon: Icon(
            CupertinoIcons.padlock,
            color: MyColors.colorprimario,
          ),
          suffixIcon: controlador.isBlindConfirm
              ? IconButton(
                  onPressed: () => controlador.mostrarConfirmar(),
                  icon: Icon(
                    CupertinoIcons.eye,
                    color: MyColors.colorprimario,
                  ),
                )
              : IconButton(
                  onPressed: () => controlador.mostrarConfirmar(),
                  icon: Icon(
                    CupertinoIcons.eye_slash,
                    color: MyColors.colorprimario,
                  ),
                ),
        ),
        obscureText: controlador.isBlindConfirm ? true : false,
      ),
    );
  }
}

class _ButtonRegister extends StatelessWidget {
  const _ButtonRegister({
    Key? key,
    required this.controlador,
  }) : super(key: key);
  final RegistroController controlador;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: LinearGradient(
          begin: Alignment(-0.95, 0.0),
          end: Alignment(1.0, 0.0),
          colors: const [Color(0xff00C9A7), Color(0xff0088C2)],
        ),
      ),
      width: double.infinity,
      height: MediaQuery.of(context).size.height > 720 ? 50 : 30,
      margin: EdgeInsets.symmetric(horizontal: 20.0)
          .copyWith(top: 40.0, bottom: 20.0),
      child: ElevatedButton(
        // onPressed:
        //     controlador.isEnable ? () => controlador.registro(context) : null,
        onPressed: () => controlador.registro(),
        child: Text(
          'Registrarme'.toUpperCase(),
          style: TextStyle(fontSize: 18.0),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.0),
          shadowColor: Colors.transparent,
        ),
      ),
    );
  }
}

class _TextHaveAcount extends StatelessWidget {
  final RegistroController controlador;
  const _TextHaveAcount({
    Key? key,
    required this.controlador,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Yá tienes una Cuenta',
          style: TextStyle(
            color: MyColors.colorprimario,
            fontSize: 16.0,
          ),
          // textAlign: TextAlign.center,
        ),
        SizedBox(width: 10.0),
        GestureDetector(
          child: Text(
            'Ingresa Aquí',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: MyColors.colorprimario,
              fontSize: 16.0,
            ),
          ),
          onTap: () => Navigator.of(context).pushNamed('login'),
        ),
      ],
    );
  }
}
