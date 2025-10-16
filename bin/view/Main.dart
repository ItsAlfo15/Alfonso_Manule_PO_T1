import 'dart:io';
import '../utils/utils.dart';

import '../controller/app_manager.dart';

import '../models/paciente_model.dart';
import '../models/medico_model.dart';
import '../models/consulta_model.dart';

import '../providers/pacientes_provider.dart';
import '../providers/medicos_provider.dart';
import '../providers/consulta_provider.dart';

void main() async {
  AppManager controlador = AppManager();

  int op = 0;

  do {
    print('Cargando datos...');
    await controlador.getDatosControlador();

    op = menuPrincipal(controlador);
    Utils.limpiaPantalla();

    switch (op) {
      case 1: //Admisión de paciente
        //admisionPaciente(controlador);
        break;
      case 2: //Liberar
        //liberarConsulta(controlador);
        break;
      case 3: //Ver cola
        pintaCola(controlador);
        break;
      case 4: //Ver estado consultas
        pintaConsultas(controlador);
        break;
      case 5:
        print("Saliendo...");
        break;
      default:
        print('Debes introducir una opción del menú.');
        stdin.readLineSync();
    }
  } while (op != 5);
} //Final del main

//Admisión de paciente
void admisionPaciente(AppManager controlador) {
  print('Insercción de un nuevo paciente');
  print('Introduce el DNI del paciente:');
  String? dni = stdin.readLineSync();
  print('Introduce el nombre del paciente:');
  String? nombre = stdin.readLineSync();
  print('Introduce los apellidos del paciente');
  String? apellidos = stdin.readLineSync();
  print('Introduce los sintomas del paciente');
  String? sintomas = stdin.readLineSync();
  if (controlador.insertaPaciente(dni, nombre, apellidos, sintomas)){
    print('Se te ha añadido a una consulta con el médico ${controlador.buscaMedicoBy(idMedicoPasado)}')
  }
}

/*
void liberarConsulta(AppManager controlador) {

  String? consultaLibreNoParse;

  do {
    print("Introduce la consulta que ha sido liberada: ");
    consultaLibreNoParse = stdin.readLineSync();
    if (consultaLibreNoParse == null) 
    print("Error, debes introducir un");
  } while (consultaLibreNoParse == null);

    int? consultaLibreParse = int.tryParse(consultaLibreNoParse);
    if (consultaLibreParse == null)
      print("Ocurrió un error vuelva a intenarlo");
    else {
      if (!controlador.consultaValidaParaLiberar(consultaLibreParse))
        print("El número de consulta no es válido");
      else {
        Paciente siguiente = controlador.liberaConsulta(consultaLibreParse);
        if (consulta.idCliente == null)
          print("Consulta liberada. No hay nadie más en la cola");
        else {
          print(
            'El paciente ${siguiente.nombre} ${siguiente.apellidos} ya puede pasar',
          );
          print('Pasa a la consulta $consultaLibreParse');
          Medico temp = controlador.recuperaMedicoConsulta(consultaLibreParse);
          print('Le atenderá ${temp.nombre}');
      }
    }
  }
}
*/
void pintaCola(AppManager controlador) {
  if (!controlador.getCola().isEmpty) {
    for (Paciente p in controlador.getCola()) {
      print(p);
    }
  } else
    print('No hay ningún paciente en la cola');

  Utils.pulsaContinuar();
}

void pintaConsultas(AppManager controlador) {
  int cont = 0;

  controlador.consultas.forEach((consulta) {
    Medico? medicoTemp = controlador.buscaMedicoByID(consulta.idMedico);
    Paciente? pacienteTemp = controlador.buscaPacienteByID(consulta.idPaciente);

    String mensajeAPintar = pacienteTemp != null
        ? '${pacienteTemp.nombre} ${pacienteTemp.apellidos}'
        : 'Sin paciente en la sala';

    String numHistoria = pacienteTemp != null
        ? '${pacienteTemp.numHistoria}'
        : '-----';

    if (medicoTemp != null) {
      cont++;
      print('============== Consulta $cont ==============');
      print('Nombre del médico: ${medicoTemp.nombre}');
      print('Especialidad: ${medicoTemp.especialidad}');
      print('Paciente: $mensajeAPintar');
      print('Num_historia: $numHistoria');
      print('========================================\n');
    }
  });
  Utils.pulsaContinuar();
  Utils.limpiaPantalla();
}

// Menus

// Metodo que pinta el menu principal
void pintaMenuPrincipal(AppManager controlador) {
  int numConsultas = controlador.numConsultas();
  int numConsultasLibres = controlador.numConsultasLibres();
  int numPacientesCola = controlador.numPacientesEnCola();
  int numPacientesCurados = controlador.numPacientesCurados();

  print('''
\nBienvenido al centro de salud de Martos
==================================================
El número de consultas es: $numConsultas
Consultas libres: $numConsultasLibres
Atucalmente, tenemos $numPacientesCola pacientes en cola
Hoy hemos curado a $numPacientesCurados pacientes
==================================================

===== MENÚ PRINCIPAL =====
1. Admisión de un paciente
2. Liberar una consulta
3. Ver la cola de espera
4. Ver el estado de las consultas
5. Salir
Seleccione una opción: 
''');
}

// Metodo que devuelve una opcion valida
int menuPrincipal(AppManager controlador) {
  int? op;

  do {
    pintaMenuPrincipal(controlador);
    op = int.tryParse(stdin.readLineSync() ?? '');
  } while (op == null);

  return op;
}
