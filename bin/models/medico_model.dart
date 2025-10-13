import 'dart:convert';
import 'dart:math';

class Medico {
  String? id;
  String especialidad;
  String nombre;

  Medico({required this.especialidad, required this.nombre});

  factory Medico.fromRawJson(String str) => Medico.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Medico.fromJson(Map<String, dynamic> json) =>
      Medico(especialidad: json["especialidad"], nombre: json["nombre"]);

  Map<String, dynamic> toJson() => {
    "especialidad": especialidad,
    "nombre": nombre,
  };

  @override
  String toString() => 'ID: ${id}, Nombre: ${nombre}, Especialidad: ${especialidad}';
}
