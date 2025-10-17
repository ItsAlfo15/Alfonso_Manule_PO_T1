import 'dart:convert';

import 'package:http/http.dart';

import '../models/paciente_model.dart';

final _urlBase =
    'https://alfonso-manule-po-t1-default-rtdb.europe-west1.firebasedatabase.app/Pacientes.json';

final _urlBaseNoJson =
    'https://alfonso-manule-po-t1-default-rtdb.europe-west1.firebasedatabase.app/Pacientes';

class PacientesProvider {
  static Future<List<Paciente>> getPacientes() async {
    // Primero genero la lista que voy a devolver
    List<Paciente> listaPacientes = [];

    // Parseo la url con Uri
    Uri uri = Uri.parse(_urlBase);

    // Me traido los datos de la api y los guardo en una Response
    Response response = await get(uri);

    // Devuelvo una lista vacia en caso de error
    if (response.statusCode != 200) return listaPacientes;

    if (response.body.isEmpty || response.body == '""') return listaPacientes;

    // Creo el mapa con la data del response
    Map<String, dynamic> resp = jsonDecode(response.body);

    // Recorro el mapa y genero un nuevo paciente asignandole el id
    resp.forEach((id, paciente) {
      // Creo el paciente
      Paciente pacienteTemp = Paciente.fromJson(paciente);

      // Le asigno el id
      pacienteTemp.idPaciente = id;

      // Lo añado a la lista
      listaPacientes.add(pacienteTemp);
    });

    // Devuelvo la lista de pacientes
    return listaPacientes;
  }

  static Future<Paciente?> getPaciente(Paciente paciente) async {
    if (paciente.idPaciente == null || paciente.idPaciente!.isEmpty) {
      return null;
    }

    Paciente? temp;

    Uri uri = Uri.parse('$_urlBaseNoJson/${paciente.idPaciente}.json');

    Response response = await get(uri);

    if (response.statusCode != 200) {
      return null;
    }

    // Creo el mapa con la data del response
    Map<String, dynamic> resp = jsonDecode(response.body);

    temp = Paciente.fromJson(resp);

    temp.idPaciente = paciente.idPaciente;

    return temp;
  }

  static Future<String?> postPaciente(Paciente paciente) async {
    Uri uri = Uri.parse(_urlBase);

    Response response = await post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(paciente.toJson()),
    );

    // Devuelvo el id que me genera firebase
    if (response.statusCode == 200 || response.statusCode == 201)
      return jsonDecode(response.body)['name'];

    return null;
  }

  static Future<int> putPaciente(Paciente paciente) async {
    Uri uri = Uri.parse('$_urlBaseNoJson/${paciente.idPaciente}.json');

    Response response = await put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(paciente.toJson()),
    );

    return response.statusCode;
  }
}
