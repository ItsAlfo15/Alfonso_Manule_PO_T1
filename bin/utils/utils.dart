import 'dart:io';

class Utils {
  static void pulsaContinuar() {
    print('Pulsa "Enter" para continuar...');
    stdin.readLineSync();
  }

  static void limpiaPantalla(){
    for (var i = 0; i < 100; i++) {
      print('');
    }
  }

  static void animacionCargando(String datoAMostrar){
    stdout.write(datoAMostrar);
    for (var i = 0; i < 3; i++) {
      sleep(Duration(milliseconds: 300));
      stdout.write('.');
    }
  }
}
