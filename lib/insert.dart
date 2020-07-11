import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'bd/crud_operations.dart';
import 'bd/students.dart';
import 'convertidor.dart';
import 'dart:async';
import 'delete.dart';
import 'login/page.dart';
import 'notes.dart';
import 'notificacion.dart';
import 'update.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(brightness: Brightness.light, primarySwatch: Colors.teal),
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.teal),
      debugShowCheckedModeBanner: false,
      home: Insert(),
    );
  }
}

class Insert extends StatefulWidget {
  @override
  _myInsert createState() => new _myInsert();
}

class _myInsert extends State<Insert> {
  // VAR MANEJO BD
  Future<List<Nota>> Notas;
  TextEditingController controllerN = TextEditingController();
  TextEditingController controllerI = TextEditingController();


  int currentUserId;
  String photo;
  String titulo;
  String descripcion;
  String hora;
  String dia;
  String semanal;
  String control;

  final formkey = new GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var dbHelper;
  bool isUpdating;


  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  void refreshList() {
    setState(() {
      Notas = dbHelper.getStudents();
    });
  }

  void cleanData() {
    controllerN.text = "";
    controllerI.text = "";
  }

  void dataValidate() async {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      if(photo == '' || photo == null){
        final snackBar = SnackBar(
          backgroundColor: Colors.tealAccent,
          content: Text('Una imagen es requerida'),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }else{
        if (isUpdating) {
          Nota no = Nota(currentUserId, photo, titulo, descripcion, hora, dia, semanal, control);
          setState(() {
            isUpdating = false;
          });
        } else {
          Nota no = Nota(null, photo, titulo, descripcion, hora, dia, semanal, control);
          var validation = await dbHelper.validateInsert(no);
          print(validation);
          if (validation) {
            print(photo);
            dbHelper.insert(no);
            final snackBar = SnackBar(
              backgroundColor: Colors.tealAccent,
              content: Text('Guardada'),
            );
            _scaffoldKey.currentState.showSnackBar(snackBar);
          } else{
            final snackBar = SnackBar(
              backgroundColor: Colors.tealAccent,
              content: Text('Lo siento esa matricula ya le pertenece a otro alumno'),
            );
            _scaffoldKey.currentState.showSnackBar(snackBar);
          }
        }

        cleanData();
        refreshList();
      }

    }
  }

  pickImagefromGallery(){
    ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 480, maxWidth: 640).then((imgFile){
      if(imgFile != null){
        String imgString = Convertir.base64String(imgFile.readAsBytesSync());
        setState(() {
          photo= imgString;
        });
        return imgString;
      }else{
        Fluttertoast.showToast(msg: "No seleccionó ninguna fotografía");
        return null;
      }
    });
  }

  pickImagefromCamara(){
    ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 480, maxWidth: 640).then((imgFile){
      if(imgFile != null){
        String imgString = Convertir.base64String(imgFile.readAsBytesSync());
        setState(() {
          photo= imgString;
          print(photo);
        });
        return imgString;
      }else{
        Fluttertoast.showToast(msg: "No se capturó ninguna una fotografía");
        return null;
      }
    });
  }


  // FORMULARIO

  Widget form() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 35, right: 35, top: 0),
        child: SingleChildScrollView(
          child: Container(
            child: Form(
              key: formkey,
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40.0, left: 90.0, right: 90.0, bottom: 20.0),
                        child: Center(
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.camera),
                                onPressed: (){
                                  pickImagefromCamara();
                                },),
                              IconButton(
                                icon: Icon(Icons.photo),
                                onPressed: (){
                                  pickImagefromGallery();
                                },),
                            ],
                          ),
                        ),
                      ),
                    ),

                    TextFormField(
                      cursorColor: Colors.teal,
                      cursorRadius: Radius.circular(10.0),
                      textCapitalization: TextCapitalization.characters,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
                      cursorWidth: 5.0,
                      controller: controllerN,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: "Titulo"),
                      validator: (val) => val.length == 0 ? 'Llena el campo' : null,
                      onSaved: (val) => titulo = val,
                    ),

                    TextFormField(
                      cursorColor: Colors.teal,
                      cursorRadius: Radius.circular(10.0),
                      textCapitalization: TextCapitalization.characters,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
                      cursorWidth: 5.0,
                      controller: controllerI,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: "Descripcion"),
                      validator: (val) => val.length == 0 ? 'Llena el campo' : null,
                      onSaved: (val) => descripcion = val,
                    ),

                    FlatButton(
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2020, 06, 27),
                              maxTime: DateTime(2022, 01, 1),
                              onChanged: (date) {
                                print('change $date');
                              }, onConfirm: (date) {
                                print('confirm $date');
                              }, currentTime: DateTime.now(),
                              locale: LocaleType.es);
                        },
                        child: Text(
                          'Selecciona la fecha',
                          style: TextStyle(color: Colors.teal),
                        )),

                    SizedBox(height: 30),
                    SingleChildScrollView(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.tealAccent),
                            ),
                            onPressed: dataValidate,
                            child: Text(isUpdating ? '' : 'Guardar'),
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.tealAccent),
                            ),
                            onPressed: () {
                              setState(() {
                                isUpdating = false;
                              });
                              cleanData();
                            },
                            child: Text("Cancel"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key:_scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Bienvenido',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black,
              ),
            ),
            ListTile(
              leading: Icon(Icons.assignment, color: Colors.tealAccent),
              title: Text('Perfil'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => PantallaSesion()));
              },
            ),
            ListTile(
              leading: Icon(Icons.add, color: Colors.tealAccent),
              title: Text('Agregar nota'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Insert()));
              },
            ),
            ListTile(
              title: Text('Corregir'),
              leading: Icon(Icons.edit, color: Colors.tealAccent),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => UpdateData()));
              },
            ),
            ListTile(
              title: Text('Elimina una nota'),
              leading: Icon(Icons.delete, color: Colors.tealAccent),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Doing()));
              },
            ),
            ListTile(
              title: Text('Notificaciones locales'),
              leading: Icon(Icons.notifications_active, color: Colors.tealAccent),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => MyHomePage()));
              },
            ),
          ],
        ),
      ),
      appBar: new AppBar(
        backgroundColor: Colors.black,
        title: Text('Notas'),
      ),
      body: new Container(
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            form(),
          ],
        ),
      ),
    );
  }
}