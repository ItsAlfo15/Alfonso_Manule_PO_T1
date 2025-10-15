import 'dart:convert';

class Consulta {
  String? idConsulta;
  String? idMedico;
  String? idPaciente;

  Consulta({required this.idMedico, required this.idPaciente});

  factory Consulta.fromRawJson(String str) =>
      Consulta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Consulta.fromJson(Map<String, dynamic> json) =>
      Consulta(idMedico: json["idMedico"], idPaciente: json["idPaciente"]);

  Map<String, dynamic> toJson() => {
    "idMedico": idMedico,
    "idPaciente": idPaciente,
  };

   @override
   String toString() => 'ID: $idConsulta, IDMedico: $idMedico, IDPaciente: $idPaciente';
}
