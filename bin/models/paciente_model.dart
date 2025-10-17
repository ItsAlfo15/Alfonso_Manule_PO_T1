import 'dart:convert';

class Paciente {
  String? idPaciente;
  String apellidos;
  String dni;
  String nombre;
  int numHistoria;
  String sintomas;
  String? fechaRegistro;
  String? fechaCurado;

  Paciente({
    required this.apellidos,
    required this.dni,
    required this.nombre,
    required this.numHistoria,
    required this.sintomas,
    required this.fechaRegistro,
    required this.fechaCurado
  });

  factory Paciente.fromRawJson(String str) =>
      Paciente.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Paciente.fromJson(Map<String, dynamic> json) => Paciente(
    apellidos: json["apellidos"],
    dni: json["dni"],
    nombre: json["nombre"],
    numHistoria: json["numHistoria"],
    sintomas: json["sintomas"],
    fechaRegistro: json['fechaRegistro'],
    fechaCurado: json["fechaCurado"],
  );

  Map<String, dynamic> toJson() => {
    "apellidos": apellidos,
    "dni": dni,
    "nombre": nombre,
    "numHistoria": numHistoria,
    "sintomas": sintomas,
    "fechaRegistro": DateTime.now().toString(),
    "fechaCurado" : fechaCurado ?? '',
  };

  @override
  String toString() => 'ID: $idPaciente, Num Historia: $numHistoria, Nombre: $nombre, Apellidos: $apellidos, Síntomas: $sintomas';

}
