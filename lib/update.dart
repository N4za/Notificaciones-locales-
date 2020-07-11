import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notifications/login/page.dart';
import 'bd/crud_operations.dart';
import 'delete.dart';
import 'insert.dart';
import 'notes.dart';
import 'bd/students.dart';
import 'dart:async';
import 'notificacion.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(brightness: Brightness.light, primarySwatch: Colors.teal),
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.teal),
      home: UpdateData(),
    );
  }
}

class UpdateData extends StatefulWidget {
  @override
  _UpdateData createState() => new _UpdateData();
}

class _UpdateData extends State<UpdateData> {
  // VAR MANEJO BD
  Future<List<Nota>> Notas;
  TextEditingController controllerN = TextEditingController();
  TextEditingController controllerAP = TextEditingController();
  TextEditingController controllerAPP = TextEditingController();
  TextEditingController controllerTE = TextEditingController();
  TextEditingController controllerC = TextEditingController();
  TextEditingController controllerM = TextEditingController();
  TextEditingController controllerUp = TextEditingController();

  int currentUserId;
  String valor;
  int opcion;
  String descriptive_text = "Nueva descripcion?";
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
    refreshList();
  }

  void refreshList() {
    setState(() {
      Notas = dbHelper.getStudents();
    });
  }

  void cleanData() {
    controllerM.text = "";
    controllerAPP.text = "";
    controllerAP.text = "";
    controllerTE.text = "";
    controllerC.text = "";
    controllerN.text = "";
    controllerUp.text = "";
  }

  void updateData(){
    print("Seleccion: ");
    print(opcion);
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      if (opcion==1) {
        titulo = controllerUp.text;
        Nota no = Nota(currentUserId, photo, titulo, descripcion, hora, dia, semanal, control);
        dbHelper.update(no);
        refreshList();
      }
      else if (opcion==2) {
        descripcion = controllerUp.text;
        Nota no = Nota(currentUserId, photo, titulo, descripcion, hora, dia, semanal, control);
        dbHelper.update(no);
        refreshList();
      }
      cleanData();
      refreshList();
    }
  }




  // SHOW DATA
  SingleChildScrollView dataTable(List<Nota> Notas) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Card(
        child: DataTable(
          columns: [
            DataColumn(
              label: Text("Titulo"),
            ),
          ],
          rows: Notas.map((student) =>
              DataRow(cells: [
                DataCell(Text(student.titulo), onTap: () {
                  setState(() {
                    descriptive_text = "Titulo";
                    currentUserId = student.controlnum;
                    valor = student.titulo;
                    opcion=1;
                  });
                  controllerUp.text = student.titulo;
                }),
              ])).toList(),
        ),
      ),
    );
  }


  Widget form() {
    return Form(
      key: formkey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            new SizedBox(height: 50.0),
            TextFormField(
              controller: controllerUp,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: descriptive_text),
              cursorColor: Colors.tealAccent,
              textCapitalization: TextCapitalization.characters,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w300),
              cursorRadius: Radius.circular(10.0),
              cursorWidth: 5.0,
              validator: (val) => val.length == 0 ? 'Hey! Olvidaste escribir la actualizacion' : null,
              onSaved: (val) => valor = val,
            ),

            SizedBox(height: 30,),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.teal),
                  ),
                  onPressed: updateData,
                  child: Text('Guardar'),
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.teal),
                  ),
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    cleanData();
                    refreshList();
                  },
                  child: Text("Cancel"),
                ),
              ],
            )
          ],
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
    return new Scaffold(      drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Bienvenido',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTA4_bxGdDNYR7_oiqOAhDb7nhTnOB3soSv7w&usqp=CAU"),
              ),
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
        title: Text('Actualizado'),
      ),
      body: new Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            form(),
            list(),
          ],
        ),
      ),
    );
  }
}