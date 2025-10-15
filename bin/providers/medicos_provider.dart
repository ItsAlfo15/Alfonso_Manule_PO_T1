import 'dart:convert';

import 'package:http/http.dart';
import '../models/medico_model.dart';

final _urlBase =
    'https://alfonso-manule-po-t1-default-rtdb.europe-west1.firebasedatabase.app/Medicos.json';

Future<List<Medico>> getMedicos() async {
  // Primero genero la lista que voy a devolver
  List<Medico> listaMedicos = [];

  // Parseo la url con Uri
  Uri uri = Uri.parse(_urlBase);

  // Me traido los datos de la api y los guardo en una Response
  Response response = await get(uri);

  // Devuelvo una lista vacia en caso de error
  if (response.statusCode != 200) return listaMedicos;

  // Creo el mapa con la data del response
  final Map<String, dynamic> resp = jsonDecode(response.body);

  // Recorro el mapa y genero un nuevo medico asignandole el id
  resp.forEach((id, medico) {
    
    // Creo el medido
    Medico medicoTemp = Medico.fromJson(medico);

    // Le asigno el id
    medicoTemp.idMedico = id;

    // Lo añado a la lista
    listaMedicos.add(medicoTemp);
  });

  // Devuelvo la lista de medicos
  return listaMedicos;
}
