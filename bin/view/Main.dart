import 'dart:io';
import 'dart:math';
import 'dart:mirrors';
import 'dart:vmservice_io';
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
        await admisionPaciente(controlador);
        break;
      case 2: //Liberar
        await liberarConsulta(controlador);
        break;
      case 3: //Ver cola
        pintaCola(controlador);
        break;
      case 4: //Ver estado consultas
        pintaConsultas(controlador);
        Utils.pulsaContinuar();
        Utils.limpiaPantalla();
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
Future<void> admisionPaciente(AppManager controlador) async {
  Paciente paciente = registroPaciente(controlador);

  bool pacienteCreado = await controlador.insertaPaciente(paciente);

  await controlador.getDatosControlador();

  Paciente? pacienteActualizado = controlador.buscaPacienteByID(paciente.idPaciente);

  if (pacienteCreado) {
    Consulta? posibleConsulta = await controlador.asignaPacienteConsulta(
      pacienteActualizado,
    );

    if (posibleConsulta != null) {
      int numConsulta = controlador.consultas.indexOf(posibleConsulta) + 1;
      print('Se le ha asignado a la consulta $numConsulta, ya puede pasar');
      Medico? medicoTemp = controlador.buscaMedicoByID(
        posibleConsulta.idMedico,
      );
      print('Le atenderá ${medicoTemp!.nombre}');
    } else {
      print('No hay ninguna consulta libre, deberá esperar su turno');
    }
  } else {
    print('Hubo un error con la inserción del paciente.');
  }

  Utils.pulsaContinuar();
}

Paciente registroPaciente(AppManager controlador) {
  String dni, nombre, apellidos, sintomas;

  print('Insercción de un nuevo paciente');

  dni = pideDniPaciente();
  nombre = pideNombrePaciente();
  apellidos = pideApellidosPaciente();
  sintomas = pideSintomasPaciente();

  // Creo el paciente
  Paciente paciente = Paciente(
    apellidos: apellidos,
    dni: dni,
    nombre: nombre,
    numHistoria: controlador.generaNumHistoria(),
    sintomas: sintomas,
    fechaRegistro: DateTime.now().toString(),
    fechaCurado: ''
  );

  return paciente;
}

String pideDniPaciente() {
  String? dni;

  // Pido el DNI y verifico que no este vacio
  do {
    print('Introduce el DNI del paciente: ');
    dni = stdin.readLineSync();

    if (dni == null || dni.trim().isEmpty) {
      print('Error, Debes introducir un valor');
    }
  } while (dni == null || dni.trim().isEmpty);

  return dni;
}

String pideNombrePaciente() {
  String? nombre;

  // Pido el nombre y verifico que no este vacio
  do {
    print('Introduce el nombre del paciente: ');
    nombre = stdin.readLineSync();

    if (nombre == null || nombre.trim().isEmpty) {
      print('Error, Debes introducir un valor');
    }
  } while (nombre == null || nombre.trim().isEmpty);

  return nombre;
}

String pideApellidosPaciente() {
  String? apellidos;

  // Pido los apellidos y verifico que no esten vacios
  do {
    print('Introduce los apellidos del paciente: ');
    apellidos = stdin.readLineSync();

    if (apellidos == null || apellidos.trim().isEmpty) {
      print('Error, Debes introducir un valor');
    }
  } while (apellidos == null || apellidos.trim().isEmpty);

  return apellidos;
}

String pideSintomasPaciente() {
  String? sintomas;

  // Pido los sitomas y verifico que no esten vacios
  do {
    print('Introduce los sintomas del paciente ');
    sintomas = stdin.readLineSync();

    if (sintomas == null || sintomas.trim().isEmpty) {
      print('Error, Debes introducir un valor');
    }
  } while (sintomas == null || sintomas.trim().isEmpty);

  return sintomas;
}


Future<void> liberarConsulta(AppManager controlador) async {

  String? numConsultaIntroducida;
  int? numConsulta;

  // Pido el num de la consulta, lo parseo y verifico
  do {
    pintaConsultas(controlador);

    print("\nIntroduce la consulta que ha sido liberada: ");
    numConsultaIntroducida = stdin.readLineSync();

    numConsulta = int.tryParse(numConsultaIntroducida!) ?? -1;

    if (numConsulta == -1) {
      print('Error, debes seleccionar una consulta.');
      Utils.pulsaContinuar();
      Utils.limpiaPantalla();
    }

    if (! await controlador.liberaConsulta(numConsulta)) numConsulta = -1;
    else {
      Consulta temp = controlador.consultas[numConsulta - 1];
      Consulta? consultaLiberada = controlador.buscaConsultaByID(temp.idConsulta);
      Paciente? siguientePaciente;
      Medico? medicoEnConsulta;

      if (consultaLiberada == null) numConsulta = -1;
      else {
        if (consultaLiberada.idPaciente == '') {
          siguientePaciente = await controlador.asignaSiguientePacienteConsulta(consultaLiberada);
          medicoEnConsulta = controlador.recuperaMedicoConsulta(consultaLiberada);

          if (siguientePaciente != null && medicoEnConsulta != null) {
          print('El paciente ${siguientePaciente.nombre} ${siguientePaciente.apellidos} ya puede pasar');
          print('Pasa a la consulta $numConsulta');
          print('Le atenderá ${medicoEnConsulta.nombre}');
          } else print('No hay pacientes en cola');
        }
      } 
    }
  } while (numConsulta == -1);
}

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
