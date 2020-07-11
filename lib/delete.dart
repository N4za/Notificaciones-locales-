import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'bd/crud_operations.dart';
import 'insert.dart';
import 'bd/students.dart';
import 'dart:async';
import 'login/page.dart';
import 'notificacion.dart';
import 'update.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(brightness: Brightness.light, primarySwatch: Colors.teal),
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.teal),
      home: Doing(),
    );
  }
}

class Doing extends StatefulWidget {
  @override
  _Doing createState() => new _Doing();
}

class _Doing extends State<Doing> {
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
    controllerI.text = "";
    controllerN.text = "";
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
  SingleChildScrollView dataTable(List<Nota> Notas) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 60.0, bottom: 20.0, right: 40.0, top: 20.0),
        child: Card(
          child: DataTable(
            columns: [
              DataColumn(
                label: Text("Delete."),
              ),
              DataColumn(
                label: Text("Titulo de la nota."),
              ),
            ],
            rows: Notas.map((student) => DataRow(cells: [
              DataCell(
                IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.tealAccent,
                  onPressed: () {
                    dbHelper.delete(student.controlnum);
                    final snackBar=SnackBar(
                      backgroundColor: Colors.tealAccent,
                      content: Text('Eliminado'),
                    );
                    _scaffoldKey.currentState.showSnackBar(snackBar);
                    refreshList();
                  },
                ),
              ),
              DataCell(Text(student.titulo.toString().toUpperCase()), onTap: () {
                setState(() {
                  isUpdating = true;
                  currentUserId = student.controlnum;
                });
                controllerN.text = student.descripcion;
              }),
            ])).toList(),
          ),
        ),
      ),
    );
  }

  Widget list() {
    return Expanded(
      child: FutureBuilder(
        future: Notas,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Text("No data founded!");
          }
          return CircularProgressIndicator();
        },
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
      body: new Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            list(),
          ],
        ),
      ),
    );
  }
}