import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:reciclon_client/src/pages/empresa/crear/empresa_crear_controller.dart';
import 'package:reciclon_client/src/utils/my_colors.dart';

class EmpresaCrearPage extends StatefulWidget {
  const EmpresaCrearPage({Key? key}) : super(key: key);

  @override
  State<EmpresaCrearPage> createState() => _EmpresaCrearPageState();
}

class _EmpresaCrearPageState extends State<EmpresaCrearPage> {
  final _controller = EmpresaCrearController();
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
        backgroundColor: MyColors.colorprimario,
        title: Text('Nueva Empresa'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            _TextFieldNombreEmpresa(
              controlador: _controller,
            ),
            _TextFieldDescription(
              controlador: _controller,
            ),
            _TextFieldRazonSocial(
              controlador: _controller,
            ),
            _TextFieldTelefono(
              controlador: _controller,
            ),
            _TextFieldDireccion(
              controlador: _controller,
            ),
            _TextFieldCorreo(
              controlador: _controller,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Material(
                elevation: 2.0,
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.search_circle,
                            color: MyColors.colorprimario,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            'Seleccione los residuos que procesa su empresa',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 16.0,
                            ),
                          )
                        ],
                      ),
                      MultiSelectDialogField(
                        selectedColor: MyColors.colorprimario,
                        items: _controller.categoriasExistentes
                            .map((e) => MultiSelectItem(e, e))
                            .toList(),
                        title: Text(
                            'Precione en las casillas para seleccionar el tipo de residuo que procesa su empresa ♻️'),
                        buttonText: Text('Seleccione'),
                        buttonIcon: Icon(CupertinoIcons.list_number_rtl),
                        barrierColor: Colors.black54,
                        onConfirm: (values) {
                          // inspect(values);
                          _controller.categoriasSeleccionadas = values;
                          refresh();
                        },
                        chipDisplay: MultiSelectChipDisplay(
                          items: _controller.categoriasSeleccionadas
                              .map((e) => MultiSelectItem(e, e))
                              .toList(),
                          onTap: (value) {
                            _controller.categoriasSeleccionadas.remove(value);
                            refresh();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0).copyWith(top: 20.0),
              child: Text(
                'Seleccione el Logo de su empresa',
                style: TextStyle(fontFamily: 'Oswald'),
              ),
            ),
            GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('selecciona el Logo de tu empresa'),
                  content: Text(
                      'Puedes tomarte o elegir una foto de tu galeria, para establecerla como logo'),
                  actions: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.pink),
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
                            MaterialStateProperty.all<Color>(Colors.orange),
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
                padding: EdgeInsets.only(top: 15.0),
                child: _controller.imageFile != null
                    ? Card(
                        color: Colors.blueGrey,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Image(
                          image: FileImage(_controller.imageFile!),
                          fit: BoxFit.cover,
                          height: 200.0,
                          width: 268.0,
                        ),
                      )
                    : Card(
                        color: Colors.blueGrey,
                        elevation: 4,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Image(
                          image: AssetImage('assets/img/no-image.png'),
                          fit: BoxFit.cover,
                          height: 200.0,
                          width: 268.0,
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: _ButtonCrearCategoria(
        controlador: _controller,
      ),
    );
  }
}

class _TextFieldCorreo extends StatelessWidget {
  const _TextFieldCorreo({
    Key? key,
    required this.controlador,
  }) : super(key: key);
  final EmpresaCrearController controlador;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: controlador.emailEmpresa,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.colorPurpura, width: 2.0),
          ),
          hintText: 'Correo de la empresa',
          hintStyle: TextStyle(
            color: MyColors.placeHolderColor,
          ),
          labelText: 'Email',
          // labelStyle: TextStyle(
          //   color: MyColors.colorprimariotexto,
          // ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.black),
          ),
          floatingLabelStyle: TextStyle(
            color: MyColors.colorprimariotexto,
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          suffixIcon: Icon(
            CupertinoIcons.mail,
            color: MyColors.oscuro,
          ),
        ),
      ),
    );
  }
}

class _TextFieldDireccion extends StatelessWidget {
  const _TextFieldDireccion({
    Key? key,
    required this.controlador,
  }) : super(key: key);
  final EmpresaCrearController controlador;

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //     // color: MyColors.primaryOpacityColor,
      //     // borderRadius: BorderRadius.circular(30.0),
      //     ),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: TextField(
        // style: TextStyle(
        //   color: MyColors.colorprimariotexto,
        // ),
        controller: controlador.direccionEmpresa,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.colorPurpura, width: 2.0),
          ),
          hintText: 'Dirección de la empresa',
          hintStyle: TextStyle(
            color: MyColors.placeHolderColor,
          ),
          labelText: 'Dirección',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.black),
          ),
          floatingLabelStyle: TextStyle(
            color: MyColors.colorprimariotexto,
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          suffixIcon: Icon(
            Icons.place,
            color: MyColors.oscuro,
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
  final EmpresaCrearController controlador;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // color: MyColors.primaryOpacityColor,
          // borderRadius: BorderRadius.circular(30.0),
          ),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: TextField(
        keyboardType: TextInputType.phone,
        // style: TextStyle(
        //   color: MyColors.colorprimariotexto,
        // ),
        controller: controlador.telefonoEmpresa,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.colorPurpura, width: 2.0),
          ),
          hintText: 'Teléfono de la empresa',
          hintStyle: TextStyle(
            color: MyColors.placeHolderColor,
          ),
          labelText: 'Teléfono',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.black),
          ),
          floatingLabelStyle: TextStyle(
            color: MyColors.colorprimariotexto,
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          suffixIcon: Icon(
            CupertinoIcons.phone_arrow_down_left,
            color: MyColors.oscuro,
          ),
        ),
      ),
    );
  }
}

class _TextFieldRazonSocial extends StatelessWidget {
  const _TextFieldRazonSocial({
    Key? key,
    required this.controlador,
  }) : super(key: key);
  final EmpresaCrearController controlador;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // color: MyColors.primaryOpacityColor,
          // borderRadius: BorderRadius.circular(30.0),
          ),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: TextField(
        // style: TextStyle(
        //   color: MyColors.colorprimariotexto,
        // ),
        controller: controlador.razonSocialEmpresa,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.colorPurpura, width: 2.0),
          ),
          hintText: 'Razón Social de la empresa',
          hintStyle: TextStyle(
            color: MyColors.placeHolderColor,
          ),
          labelText: 'Razón Social',
          // labelStyle: TextStyle(
          //   color: MyColors.colorprimariotexto,
          // ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.black),
          ),
          floatingLabelStyle: TextStyle(
            color: MyColors.colorprimariotexto,
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          suffixIcon: Icon(
            Icons.home_work_outlined,
            color: MyColors.oscuro,
          ),
        ),
      ),
    );
  }
}

class _TextFieldNombreEmpresa extends StatelessWidget {
  const _TextFieldNombreEmpresa({
    Key? key,
    required this.controlador,
  }) : super(key: key);
  final EmpresaCrearController controlador;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // color: MyColors.primaryOpacityColor,
          // borderRadius: BorderRadius.circular(30.0),
          ),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: TextField(
        // style: TextStyle(
        //   color: MyColors.colorprimariotexto,
        // ),
        controller: controlador.nombreEmpresa,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.colorPurpura, width: 2.0),
          ),
          hintText: 'Nombre de la Empresa',
          hintStyle: TextStyle(
            color: MyColors.placeHolderColor,
          ),
          labelText: 'Nombre',
          // labelStyle: TextStyle(
          //   color: MyColors.colorprimariotexto,
          // ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.black),
          ),
          floatingLabelStyle: TextStyle(
            color: MyColors.colorprimariotexto,
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          suffixIcon: Icon(
            CupertinoIcons.textformat_abc_dottedunderline,
            color: MyColors.oscuro,
          ),
        ),
      ),
    );
  }
}

class _TextFieldDescription extends StatelessWidget {
  const _TextFieldDescription({
    Key? key,
    required this.controlador,
  }) : super(key: key);
  final EmpresaCrearController controlador;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      decoration: BoxDecoration(
          // color: MyColors.primaryOpacityColor,
          // borderRadius: BorderRadius.circular(30.0),
          ),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: TextField(
        maxLength: 255,
        minLines: 3,
        maxLines: 12,
        keyboardType: TextInputType.multiline,
        // style: TextStyle(
        //   color: MyColors.colorprimariotexto,
        // ),
        controller: controlador.descripcionEmpresa,
        textInputAction: TextInputAction.next,
        // onSubmitted: (texto) => controlador.crearCategoria(),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.colorPurpura, width: 2.0),
          ),
          hintText: 'Descripción de la empresa',
          hintStyle: TextStyle(
            color: MyColors.placeHolderColor,
          ),
          labelText: 'Descripción',
          // labelStyle: TextStyle(
          //   color: MyColors.colorprimariotexto,
          // ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.black),
          ),
          floatingLabelStyle: TextStyle(
            color: MyColors.colorprimariotexto,
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
          suffixIcon: Icon(
            CupertinoIcons.line_horizontal_3_decrease,
            color: MyColors.oscuro,
          ),
        ),
      ),
    );
  }
}

class _ButtonCrearCategoria extends StatelessWidget {
  const _ButtonCrearCategoria({
    Key? key,
    required this.controlador,
  }) : super(key: key);
  final EmpresaCrearController controlador;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height > 720 ? 50 : 30,
      margin: EdgeInsets.symmetric(horizontal: 20.0)
          .copyWith(top: 40.0, bottom: 20.0),
      child: ElevatedButton(
        onPressed: () => controlador.crearEmpresa(),
        child: Text('Crear Empresa'.toUpperCase()),
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
