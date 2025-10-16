import 'dart:convert';

import 'package:http/http.dart';

import '../models/paciente_model.dart';

final _urlBase =
    'https://alfonso-manule-po-t1-default-rtdb.europe-west1.firebasedatabase.app/Pacientes.json';

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

  static Future<int> postPaciente(Paciente paciente) async {
    Uri uri = Uri.parse(_urlBase);

    Response response = await post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(paciente.toJson()),
    );

    return response.statusCode;
  }
}
