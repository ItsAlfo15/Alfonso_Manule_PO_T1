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
}
