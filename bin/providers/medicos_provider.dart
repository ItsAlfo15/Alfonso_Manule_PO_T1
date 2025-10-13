import 'dart:convert';

import 'package:http/http.dart';
import '../models/medico_model.dart';

final _urlBase =
    'https://alfonso-manule-po-t1-default-rtdb.europe-west1.firebasedatabase.app/Medicos.json';

Future<List<dynamic>> getMedicos() async {
  List<dynamic> listaMedicos = [];

  Uri uri = Uri.parse(_urlBase);

  Response response = await get(uri);

  if (response.statusCode != 200) return listaMedicos;

  final Map<String, dynamic> resp = jsonDecode(response.body);

  resp.forEach(action)

  return listaMedicos;
}
