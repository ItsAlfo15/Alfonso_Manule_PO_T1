import 'dart:io';

import '../controller/app_manager.dart';

import '../models/paciente_model.dart';
import '../models/medico_model.dart';
import '../models/consulta_model.dart';

import '../providers/pacientes_provider.dart';
import '../providers/medicos_provider.dart';
import '../providers/consulta_provider.dart';

void main() async {

  AppManager controlador = AppManager();

  await controlador.getDatosControlador();

  print(controlador.medicos.length);

  /*
  int op = 0

  List<Paciente> pacientes = controlador.pacientes;
  List<Medico> medicos = controlador.medicos; 
  List<Consulta> consultas = controlador.consultas;
  
  print("=== PACIENTES ===");
  pacientes.forEach(print);

  print("\n=== MÉDICOS ===");
  medicos.forEach(print);

  print("\n=== CONSULTAS ===");
  consultas.forEach(print);

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
        switch (op) {
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

Function admisionPaciente(AppManager controlador) {
  String? dni = stdin.readLineSync();
  String? nombre = stdin.readLineSync();
  String? apellidos = stdin.readLineSync();
  String? sintomas = stdin.readLineSync();
  int resultado = controlador.admisionPaciente(
    nombre,
    apellidos,
    dni,
    sintomas,
  );
  if (resultado == -1)
    print("No hay ninguna consulta libre, debe esperar en la cola");
  else
    print(
      "Se le ha asignado la consulta $resultado, ya puede pasar. Le atenderá ${controlador.nombreMedicoEnConsulta(resultado)}",
    );
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
        if (siguiente == null) print("Consulta liberada. No hay nadie más en la cola");
        else{
          print('El paciente ${siguiente.getNombre()} ${siguiente.getApellidos()} ya puede pasar');
          print('Pasa a la consulta $consultaLibreParse');
          print('Le atenderá ${controlador.nombreMedicoEnConsulta(consultaLibreParse)}');
        }
      }
    }
  }
}

Function pintaCola(AppManager controlador){
  for (Paciente p in controlador.getCola()) {
    print(p);
  }
}

Function pintaConsulta(Consulta c, int num){
  print('===== Consulta $num =====');
  print('Médico ${c.getMedico() == null ? 'Sin médico' : c.getMedico().getNombre()}');
  if (c.getMedico() != null){
    print('Especialidad ${c.getMedico()}')
  }
}

Function pintaMenuPrincipal() {

  int numConsultas = controlador.numConsultas();
  int numConsultasLibres = controlador.numConsultasLibres();
  int numPacientesCola = controlador.numPacientesEnCola();
  int numPacientesCurados = controlador.numPacientesCurados();

  print('''
    Bienvenido al centro de salud de Martos
    ==================================================
    El número de consultas es: $numConsultas
    Consultas libres: $numConsultasLibres
    Atucalmente, tenemos $numPacientesCola pacientes en cola
    Hoy hemos curado a $numPacientesCurados pacientes
    ==================================================
    === MENÚ PRINCIPAL ===
    1. Admisión de un paciente
    2. Liberar una consulta
    3. Ver la cola de espera
    4. Ver el estado de las consultas
    5. Salir
    Seleccione una opción: 
''');

*/
}
