import 'dart:io';

import '../constructor/AppManager.dart';
import '../models/paciente.dart';

void main() {
  AppManager controlador = AppManager();
  int op = 0;

  do {
    String? input = stdin.readLineSync();
  if (input == null) {
    print('No se recibió entrada');
  } else {
    int? parsed = int.tryParse(input);
    if (parsed == null) {
      print('Valor incorrecto, intentaló de nuevo');
    } else {
      op = parsed;
      switch(op){
        case 1: //Admisión de paciente
          admisionPaciente(controlador);
          break;
        case 2: //Liberar
          liberarConsulta(controlador);
          break;
        case 3: //Ver cola
          pintaCola(controlador);
          break;
        case 4: //Ver estado consultas
          pintaConsultas(controlador);
          break;
        case 5: //Busqueda
          buscaPacientes(controlador);
          break;
      }
    }
  }
  } while (op != 6);
  
}

Function admisionPaciente(AppManager controlador){
  String? dni = stdin.readLineSync();
  String? nombre = stdin.readLineSync();
  String? apellidos = stdin.readLineSync();
  String? sintomas = stdin.readLineSync();
  int resultado = controlador.admisionPaciente(nombre, apellidos, dni, sintomas);
  if (resultado == -1) print("No hay ninguna consulta libre, debe esperar en la cola");
  else print("Se le ha asignado la consulta $resultado, ya puede pasar. Le atenderá ${controlador.nombreMedicoEnConsulta(resultado)}");
}

Function liberarConsulta(AppManager controlador){
  print("Introduce la consulta que ha sido liberada: ");
  String? consultaLibreNoParse = stdin.readLineSync();
  if (consultaLibreNoParse == null){
    print("Ocurrió un error vuelva a intenarlo");
  }else{
    int? consultaLibreParse = int.tryParse(consultaLibreNoParse);
    if (consultaLibreParse == null) print("Ocurrió un error vuelva a intenarlo");
    else{
      if (!controlador.consultaValidaParaLiberar(consultaLibreParse)) print("El número de consulta no es válido");
      else{
        Paciente siguiente = controlador.liberaConsulta(consultaLibreParse);
        if (siguiente == null) print("");
      }
    }
  }
}