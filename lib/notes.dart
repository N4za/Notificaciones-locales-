import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notifications/update.dart';
import 'bd/crud_operations.dart';
import 'delete.dart';
import 'insert.dart';
import 'login/page.dart';
import 'bd/students.dart';
import 'package:image_picker/image_picker.dart';

import 'notificacion.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(brightness: Brightness.light, primarySwatch: Colors.teal),
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.teal),
      home: Profile(),
    );
  }
}

class Profile extends StatefulWidget {
  @override
  _Profile createState() => new _Profile();
}

class _Profile extends State<Profile> {
  // VAR MANEJO BD
  List<Nota> Notas;
  TextEditingController controllerN = TextEditingController();
  TextEditingController controllerAP = TextEditingController();
  TextEditingController controllerAPP = TextEditingController();
  TextEditingController controllerTE = TextEditingController();
  TextEditingController controllerC = TextEditingController();
  TextEditingController controllerM = TextEditingController();
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
  var dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    Notas = [];
    refreshList();
  }

  void refreshList() {
    setState(() {
      dbHelper.getStudents().then((imgs){
        setState(() {
          Notas.clear();
          Notas.addAll(imgs);
        });
      });
    });
  }

  void cleanData() {
    controllerN.text = "";
    controllerI.text = "";
  }

  void dataValidate() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      if (isUpdating) {
        Nota no = Nota(currentUserId, photo, titulo, descripcion, hora, dia, semanal, control);
        dbHelper.update(no);
        setState(() {
          isUpdating = false;
        });
      } else {
        Nota no = Nota(null, photo, titulo, descripcion, hora, dia, semanal, control);
        dbHelper.insert(no);
      }
      cleanData();
      refreshList();
    }
  }

  // SHOW DATA
  Widget dataTable() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: ListView(
          children:
          Notas.map((foto)=> new InkWell(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    height: 530.0,
                    width:  250.09,
                    decoration: new BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.pink, Colors.black],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(0.8, 0.0),
                          tileMode: TileMode.clamp
                      ),
                    ),
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 110.0, right: 80.0),
                            child: new Row(
                              children: <Widget>[
                                new IconButton(icon: Icon(Icons.camera, color: Colors.tealAccent),
                                    onPressed: (){
                                      setState(() {
                                        currentUserId = foto.controlnum;
                                        titulo = foto.titulo;
                                        descripcion = foto.descripcion;
                                        hora = foto.hora;
                                        dia = foto.dia;
                                        semanal = foto.semanal;
                                        control = foto.control;
                                      });
                                    }),
                                new IconButton(icon: Icon(Icons.photo, color: Colors.tealAccent), onPressed: (){
                                  setState(() {
                                    currentUserId = foto.controlnum;
                                    titulo = foto.titulo;
                                    descripcion = foto.descripcion;
                                    hora = foto.hora;
                                    dia = foto.dia;
                                    semanal = foto.semanal;
                                    control = foto.control;
                                  });
                                }),
                              ],
                            ),
                          ),
                          new Column(
                            children: <Widget>[

                              new Text("Nazareth",
                                style: TextStyle(fontFamily: 'Piedra', color: Colors.black, fontStyle: FontStyle.normal, fontSize: 46, letterSpacing: 5.0),
                              ),

                              new Text("FLUTTER DEV" + "\n",
                                style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic, fontSize: 16, letterSpacing: 13.0),
                              ),

                              /* const Text.rich(
                                  TextSpan(text: "____________________")
                              ),
                            */

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Container(
                                  color: Colors.black,
                                  height: 3,
                                  width: 190,
                                ),
                              ),

                              new SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Container(
                                      width: 280,
                                      color: Colors.black,
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(Icons.portrait, color: Colors.tealAccent),
                                          ),
                                          new Text(
                                              foto.titulo.toString() + " " + foto.descripcion.toString() + " " + foto.control.toString(),
                                              style: TextStyle(fontFamily: 'RobotoMono', color: Colors.black)
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                              ),


                              new SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Container(
                                      width: 280,
                                      color: Colors.black,
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(Icons.email, color: Colors.tealAccent),
                                          ),
                                          new Text(
                                              foto.descripcion.toString(),
                                              style: TextStyle(fontFamily: 'RobotoMono', color: Colors.black)
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                              ),

                              new SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Container(
                                      width: 280,
                                      color: Colors.black,
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(Icons.phone, color: Colors.tealAccent),
                                          ),
                                          new Text(
                                              foto.titulo.toString(),
                                              style: TextStyle(fontFamily: 'RobotoMono', color: Colors.black)
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]
                    )
                ),
              ),
            ),
          )).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(      drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Bienvenido',
              style: TextStyle(color: Colors.pink, fontWeight: FontWeight.w300),
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
      body:
      dataTable(),
    );
  }
}