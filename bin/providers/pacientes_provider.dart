import 'dart:convert';

import 'package:http/http.dart';
import '../models/paciente_model.dart';

final url_base = 'https://alfonso-manule-po-t1-default-rtdb.europe-west1.firebasedatabase.app/Pacientes.json';

Future<List<Paciente>> getPacientes() async{ 
  List<Paciente> listaPacientes = [];
  Uri uri = Uri.parse(url_base);
  Response response = get(uri);
  if (response.statusCode != 200) return pacientes;
  Map<String, dynamic> resp = jsonDecode(response.body);
  resp.forEach((id, paciente){
    Paciente pacienteTemp = Paciente.fromJson(paciente);
    pacienteTemp.id = id;
    listaPacientes.add(pacienteTemp);
  });
  return listaPacientes;
}