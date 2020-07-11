import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'students.dart';
import 'dart:async';

class DBHelper {
  static Database _db;
  static const String Id = 'controlnum';
  static const String PHOTO_NAME = 'photoName';
  static const String TITULO = 'titulo';
  static const String DESCRIPCION = 'descripcion';
  static const String HORA = 'hora';
  static const String DIA = 'dia';
  static const String SEMANAL = 'semanal';
  static const String CONTROL = 'control';
  static const String SEARCH = '1';
  static const String COMPARACION = 'comparacion';
  static const String TABLE = 'Notaas';
  static const String DB_NAME = 'Reminder.db';

  // CREACION DB (VERIFICACION)
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  // CREACION DATABASE
  initDb() async {
    io.Directory appDirectory = await getApplicationDocumentsDirectory();
    print(appDirectory);
    String path = join(appDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($Id INTEGER PRIMARY KEY AUTOINCREMENT, $PHOTO_NAME TEXT, $TITULO TEXT, $DESCRIPCION TEXT, $HORA TEXT, $DIA TEXT, $SEMANAL TEXT, $CONTROL TEXT)");
  }

  // SELECT
  Future<List<Nota>> getStudents() async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .query(TABLE, columns: [Id, PHOTO_NAME, TITULO, DESCRIPCION, HORA, DIA, SEMANAL, CONTROL]);
    List<Nota> students = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        students.add(Nota.fromMap(maps[i]));
      }
    }
    return students;
  }



  // SAVE O INSERT
  Future<bool> validateInsert(Nota student) async {
    var dbClient = await db;
    var code = student.control;
    List<Map> maps = await dbClient
        .rawQuery("select $Id from $TABLE where $CONTROL = $code");
    if (maps.length == 0) {
      return true;
    }else{
      return false;
    }
  }

  Future<Nota> insert(Nota student) async {
    var dbClient = await db;
    student.controlnum = await dbClient.insert(TABLE, student.toMap());
    return student;
  }

  // DELETE
  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$Id = ?', whereArgs: [id]);
  }

  // UPDATE
  Future<int> update(Nota student) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, student.toMap(),
        where: '$Id = ?', whereArgs: [student.controlnum]);
  }

  // CLOSE
  Future closedb() async {
    var dbClient = await db;
    dbClient.close();
  }
}