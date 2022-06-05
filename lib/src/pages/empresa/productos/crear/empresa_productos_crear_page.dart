import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reciclon_client/src/pages/empresa/productos/crear/empresa_productos_crear_controller.dart';
import 'package:reciclon_client/src/utils/my_colors.dart';

class EmpresaProductosCrearPage extends StatefulWidget {
  const EmpresaProductosCrearPage({Key? key}) : super(key: key);

  @override
  State<EmpresaProductosCrearPage> createState() =>
      _EmpresaProductosCrearPageState();
}

class _EmpresaProductosCrearPageState extends State<EmpresaProductosCrearPage> {
  final _controller = EmpresaProductosCrearController();

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
      body: ListView(
        children: [
          SizedBox(height: 20),
          _TextFieldNombre(controlador: _controller),
          _TextFieldDescription(controlador: _controller),
          _TextFieldPrecio(controlador: _controller),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _CardImage(
                imageFile: _controller.imagen1,
                numberFile: 1,
                controlador: _controller,
              ),
              _CardImage(
                imageFile: _controller.imagen2,
                numberFile: 2,
                controlador: _controller,
              ),
              _CardImage(
                imageFile: _controller.imagen3,
                numberFile: 3,
                controlador: _controller,
              ),
            ],
          ),
          SizedBox(height: 40),
          _DropDownCategorias(
            controlador: _controller,
          ),
        ],
      ),
      bottomNavigationBar: _ButtonCrearCategoria(
        controlador: _controller,
      ),
    );
  }
}

class _DropDownCategorias extends StatefulWidget {
  const _DropDownCategorias({
    Key? key,
    required this.controlador,
  }) : super(key: key);

  final EmpresaProductosCrearController controlador;

  @override
  State<_DropDownCategorias> createState() => _DropDownCategoriasState();
}

class _DropDownCategoriasState extends State<_DropDownCategorias> {
  @override
  Widget build(BuildContext context) {
    // print(widget.controlador.categorias);
    return Container(
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
                    'Tipo de Material',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 16.0,
                      fontFamily: 'Oswald',
                    ),
                  )
                ],
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 20.0).copyWith(top: 5.0),
                child: DropdownButton(
                  underline: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_drop_down_circle_sharp,
                      color: MyColors.colorprimario,
                      size: 26,
                    ),
                  ),
                  items: _dropDownItems(widget.controlador.categorias),
                  value: widget.controlador.idCategoria,
                  onChanged: (opcion) {
                    // print('la opcion es: $opcion');
                    setState(() {
                      widget.controlador.idCategoria = opcion.toString();
                    });
                  },
                  elevation: 3,
                  isExpanded: true,
                  hint: Text(
                    'Seleccionar la categoria del material',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                      fontFamily: 'Oswald',
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(
      List<Map<String, dynamic>>? categorias) {
    List<DropdownMenuItem<String>> lista = [];
    for (var categoria in categorias!) {
      lista.add(DropdownMenuItem(
        child: Text(
          categoria['nombre'],
          style: TextStyle(
            fontFamily: 'Oswald',
          ),
        ),
        value: categoria['id'],
      ));
    }
    return lista;
  }
}

class _CardImage extends StatelessWidget {
  const _CardImage({
    Key? key,
    required this.imageFile,
    required this.numberFile,
    required this.controlador,
  }) : super(key: key);
  final File? imageFile;
  final int numberFile;
  final EmpresaProductosCrearController controlador;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('selecciona una imagen'),
          content: Text(
              'Puedes tomarte o elegir una foto de tu galeria, para establecerla como imagen del material de reciclaje'),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
              ),
              onPressed: () {
                controlador.selectImage(ImageSource.gallery, numberFile);
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
                controlador.selectImage(ImageSource.camera, numberFile);
                // selectImage(ImageSource.gallery, context, refresh);
              },
              child: Text('camara'),
            ),
          ],
        ),
      ),
      child: imageFile != null
          ? Card(
              elevation: 3.0,
              child: SizedBox(
                height: 120.0,
                width: MediaQuery.of(context).size.width * 0.26,
                child: Image.file(
                  imageFile!,
                  fit: BoxFit.cover,
                ),
              ),
            )
          : Card(
              clipBehavior: Clip.antiAlias,
              elevation: 3.0,
              child: SizedBox(
                height: 120.0,
                width: MediaQuery.of(context).size.width * 0.26,
                child: Image(
                  image: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
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
  final EmpresaProductosCrearController controlador;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: TextField(
        minLines: 1,
        maxLines: 2,
        maxLength: 180,
        style: TextStyle(
          color: MyColors.colorprimariotexto,
        ),
        controller: controlador.nombreMaterial,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.colorPurpura, width: 2.0),
          ),
          hintText: 'p.e: cables electricos',
          hintStyle: TextStyle(
            fontFamily: 'Oswald',
          ),
          labelText: 'Nombre',
          labelStyle: TextStyle(
            fontFamily: 'Oswald',
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.black),
          ),
          floatingLabelStyle: TextStyle(
            color: Colors.black,
            fontFamily: 'Oswald',
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          suffixIcon: Icon(
            CupertinoIcons.textformat_abc_dottedunderline,
            color: Colors.grey,
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
  final EmpresaProductosCrearController controlador;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
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
        style: TextStyle(
          color: MyColors.colorprimariotexto,
        ),
        controller: controlador.descripcionMaterial,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.colorPurpura, width: 2.0),
          ),
          hintText: 'Descripción del Producto',
          hintStyle: TextStyle(
            color: MyColors.placeHolderColor,
            fontFamily: 'Oswald',
          ),
          labelText: 'Descripción',
          labelStyle: TextStyle(
            // color: MyColors.colorprimariotexto,
            fontFamily: 'Oswald',
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.black),
          ),
          floatingLabelStyle: TextStyle(
            color: Colors.black,
            fontFamily: 'Oswald',
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
          suffixIcon: Icon(
            CupertinoIcons.line_horizontal_3_decrease,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class _TextFieldPrecio extends StatelessWidget {
  const _TextFieldPrecio({
    Key? key,
    required this.controlador,
  }) : super(key: key);
  final EmpresaProductosCrearController controlador;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // color: MyColors.primaryOpacityColor,
          // borderRadius: BorderRadius.circular(30.0),
          ),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: TextField(
        style: TextStyle(
          color: MyColors.colorprimariotexto,
        ),
        keyboardType: TextInputType.number,
        controller: controlador.precioMaterial,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.colorPurpura, width: 2.0),
          ),
          hintText: 'P.e: 5.12',
          hintStyle: TextStyle(
            color: MyColors.placeHolderColor,
            fontFamily: 'Oswald',
          ),
          labelText: 'Precio',
          labelStyle: TextStyle(
            // color: MyColors.colorprimariotexto,
            fontFamily: 'Oswald',
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.black),
          ),
          floatingLabelStyle: TextStyle(
            color: Colors.black,
            fontFamily: 'Oswald',
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          suffixIcon: Icon(
            CupertinoIcons.money_dollar,
            color: Colors.grey,
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
  final EmpresaProductosCrearController controlador;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height > 720 ? 50 : 30,
      margin: EdgeInsets.symmetric(horizontal: 20.0)
          .copyWith(top: 40.0, bottom: 20.0),
      child: ElevatedButton(
        // onPressed: () {},
        onPressed: () => controlador.crearMaterial(),
        child: Text('Crear Producto'.toUpperCase()),
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
