import 'dart:convert';
import '../models/consulta_model.dart';
import 'package:http/http.dart';

final _urlBase = 'https://alfonso-manule-po-t1-default-rtdb.europe-west1.firebasedatabase.app/Consultas.json';

//Async porque devuelve un Future asíncrono
Future<List<Consulta>> getConsultas() async{
  //Creamos arrays consultas
  List<Consulta> consultas = [];

  //Creamos el uri y parseamos para recibir la respuesta
  Uri uri = Uri.parse(_urlBase);
  Response response = await get(uri);

  if (response.statusCode != 200) return consultas; //Si la respuesta no es OK abortamos y retonarmos el array vacío

  Map<String, dynamic> consultasJson = jsonDecode(response.body); //Creamos el mapa de las consultas sobre el cuerpo de la respuesta mediante jsonDecode
  //Foreach para el mapa consultas
  consultasJson.forEach((id, consulta){
    Consulta consultaTemp = Consulta.fromJson(consulta);
    consultaTemp.id = id; //La id de firebase la metemos en nuestro objeto
    consultas.add(consultaTemp); //Añadimos la consulta al array de consultas
  });
  return consultas; //Retornamos las consultas
}





