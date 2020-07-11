import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../notes.dart';
import '../notificacion.dart';
import 'page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
      ThemeData(
          brightness: Brightness.dark, primarySwatch: Colors.pink),
      darkTheme: ThemeData(
          brightness: Brightness.light, primarySwatch: Colors.teal),
      home: Scaffold(
          body:PageView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              _View(),
              MyAppN(),
            ],
          )
      ),
    );
  }

  Stack _View() {
    return Stack(
      children: <Widget>[
        _Logo(),
        _Bienvenido(),
      ],
    );
  }
  Widget _Logo() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Image(image: AssetImage('assets/fercha_perfil.jpeg'),
          fit: BoxFit.cover),
    );
  }

  Widget _Bienvenido() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(child: Container()
          ),
          Icon(
              Icons.keyboard_arrow_down,
              size: 70.0,
              color: Colors.teal
          )
        ],
      ),
    );
  }
}

class MyAppN extends StatefulWidget {
  @override
  _MyAppNState createState() => _MyAppNState();
}

class _MyAppNState extends State<MyAppN> {
  final _nombre = TextEditingController();
  final _correo = TextEditingController();
  final _contra = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  SharedPreferences entrada;
  bool usuario;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sesion();
  }

  void sesion() async {
    entrada = await SharedPreferences.getInstance();
    usuario = entrada.getBool('carga') ?? false;
    print(usuario);

    if (usuario == false) {
      Navigator.push(
        context, new MaterialPageRoute(
          builder: (context) => PantallaSesion()

      ),
      );
    }
  }

  @override
  void dispose() {
    _nombre.dispose();
    _correo.dispose();
    _contra.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 650.0,
                  width: 500.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/fercha.jpeg'),
                    ),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 87.0, bottom: 16.0),
                            child: CircleAvatar(
                              minRadius: 90,
                              maxRadius: 90,
                              backgroundImage: NetworkImage("https://www.kindpng.com/picc/m/78-785827_user-profile-avatar-login-account-male-user-icon.png"),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30, right: 15, left: 15, bottom: 10),
                          child: TextFormField(
                            cursorColor: Colors.grey,
                            cursorRadius: Radius.circular(8.0),
                            cursorWidth: 8.0,
                            controller: _nombre,
                            decoration: InputDecoration(
                              focusColor: Colors.pink,
                              hoverColor: Colors.teal,
                              fillColor: Colors.grey,
                              icon: Icon(Icons.perm_contact_calendar, color: Colors.tealAccent),
                              border: OutlineInputBorder(),
                              labelText: 'Nombre: ',
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right: 15, left: 15, bottom: 10),
                          child: TextFormField(
                            cursorColor: Colors.grey,
                            cursorRadius: Radius.circular(8.0),
                            cursorWidth: 8.0,
                            controller: _correo,
                            decoration: InputDecoration(
                              icon: Icon(Icons.email, color: Colors.tealAccent),
                              border: OutlineInputBorder(),
                              labelText: 'Correo: ',
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right: 15, left: 15),
                          child: TextFormField(
                            cursorColor: Colors.grey,
                            cursorRadius: Radius.circular(8.0),
                            cursorWidth: 8.0,
                            obscureText: true,
                            controller: _contra,
                            decoration: InputDecoration(
                              icon: Icon(Icons.featured_play_list, color: Colors.tealAccent),
                              border: OutlineInputBorder(),
                              labelText: 'Contraseña: ',
                            ),
                          ),
                        ),

                        RaisedButton(
                          textColor: Colors.black,
                          splashColor: Colors.teal,
                          textTheme: ButtonTextTheme.accent,
                          color: Colors.teal[500],
                          onPressed: () {
                            String nombre = _nombre.text;
                            String correo = _correo.text;
                            String contra = _contra.text;

                            if(!correo.contains("@")){
                              showInSnackBar("Inserta una dirección de correo válida.");
                            }
                            else if (nombre != '' && contra != '' && correo != '') {
                              entrada.setBool('carga', false);
                              entrada.setString('nombre', nombre);
                              entrada.setString('correo', correo);


                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) => PantallaSesion()));

                            }
                            else {
                              showInSnackBar("Heey, no te olvides de llenar el formulario.");
                              print("Falta llenar el formulario.");
                            }
                          },
                          child: Text("Entrar"),
                        )
                      ]
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(
        backgroundColor: Colors.teal,
        content: new Text(value)
    ));
  }
}