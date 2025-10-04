import 'dart:io';

import '../controller/app_manager.dart';

void main() {
  AppManager controlador = AppManager();
  int op = 0;

  // Leer la línea como String? y parsear a int
  String? input = stdin.readLineSync();
  if (input == null) {
    print('No se recibió entrada');
  } else {
    int? parsed = int.tryParse(input);
    if (parsed == null) {
      print('Entrada no válida: $input');
    } else {
      op = parsed;
      print(op);
    }
  }
}