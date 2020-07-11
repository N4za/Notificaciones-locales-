class Nota{
  int controlnum;
  String photoName;
  String titulo;
  String descripcion;
  String hora;
  String dia;
  String semanal;
  String control;

  Nota (this.controlnum, this.photoName, this.titulo, this.descripcion, this.hora, this.dia, this.semanal, this.control);
  Map<String,dynamic>toMap(){
    var map = <String,dynamic>{
      'controlnum': controlnum,
      'photoName':photoName,
      'titulo': titulo,
      'descripcion': descripcion,
      'hora': hora,
      'dia': dia,
      'semanal': semanal,
      'control': control,
    };
    return map;
  }

  Nota.fromMap(Map<String, dynamic>map){
    controlnum = map['controlnum'];
    photoName = map['photoName'];
    titulo = map['titulo'];
    descripcion = map['descripcion'];
    hora = map['hora'];
    dia = map['dia'];
    semanal = map['semanal'];
    control = map['control'];
  }
}