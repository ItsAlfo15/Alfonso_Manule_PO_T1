import 'dart:convert';

class Consulta {
  String? idConsulta;
  String? idMedico;
  String? idPaciente;
  bool libre;

  Consulta({required this.idMedico, required this.idPaciente, required this.libre});

  factory Consulta.fromRawJson(String str) =>
      Consulta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Consulta.fromJson(Map<String, dynamic> json) =>
      Consulta(idMedico: json["idMedico"], idPaciente: json["idPaciente"], libre: json["libre"]);

  Map<String, dynamic> toJson() => {
    "idMedico": idMedico,
    "idPaciente": idPaciente ?? "",
    "libre": libre,
  };

  @override
  String toString() =>
      'ID: $idConsulta, IDMedico: $idMedico, IDPaciente: $idPaciente, Libre: $libre';
}
