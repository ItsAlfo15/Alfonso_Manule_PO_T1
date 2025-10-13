import 'package:http/http.dart';
import '../models/medico_model.dart';

final _urlBase =
    'https://alfonso-manule-po-t1-default-rtdb.europe-west1.firebasedatabase.app/Medicos';

Medico? getMedico() async {
  Medico medico;

  Uri uri = Uri.parse(_urlBase);

  Response response = await get(uri);

  if (response.statusCode != 200) return null;

  
}
