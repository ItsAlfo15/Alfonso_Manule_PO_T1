import 'dart:async';
import 'dart:developer';
import 'dart:math';

import '../models/paciente_model.dart';
import '../models/medico_model.dart';
import '../models/consulta_model.dart';

import '../providers/pacientes_provider.dart';
import '../providers/medicos_provider.dart';
import '../providers/consulta_provider.dart';

class AppManager {
  // Atributos
  List<Medico> medicos = [];
  List<Paciente> pacientes = [];
  List<Consulta> consultas = [];

  // Inicializacion de datos
  getDatosControlador() async {
    medicos = await MedicosProvider.getMedicos();
    pacientes = await PacientesProvider.getPacientes();
    consultas = await ConsultasProvider.getConsultas();
  }

  // Constructor
  AppManager();

  // Funciones
  int numConsultas() {
    return consultas.length;
  }

  int numConsultasLibres() {
    int cont = 0;

    for (var consulta in consultas) {
      if (consulta.idPaciente == '') cont++;
    }

    return cont;
  }

  int numPacientesEnCola() {
    return getCola().length;
  }

  int numPacientesCurados() {
    return -1;
  }

  Medico? buscaMedicoByID(String? idMedicoPasado) {
    for (var medico in medicos) {
      if (medico.idMedico == idMedicoPasado) return medico;
    }
    return null;
  }

  Paciente? buscaPacienteByID(String? idPacientePasado) {
    for (var paciente in pacientes) {
      if (paciente.idPaciente == idPacientePasado) return paciente;
    }
    return null;
  }

  List<Paciente> getCola() {
    // Me traigo todos los pacientes
    List<Paciente> cola = pacientes.toList();

    // Recorro las consultas
    for (var consula in consultas) {
      if (consula.idPaciente != null) {
        // Recorro los pacientes
        for (var paciente in pacientes) {
          // Si hay un paciente en consulta lo elimino de la cola
          if (consula.idPaciente == paciente.idPaciente) cola.remove(paciente);
        }
      }
    }

    return cola;
  }

  int generaNumHistoria() {
    Random random = Random();
    int numGenerado;

    do {
      numGenerado = random.nextInt(90000) + 10000;
    } while (existeNumHistoriaPaciente(numGenerado));

    return numGenerado;
  }

  bool existeNumHistoriaPaciente(int numGenerado) {
    for (var paciente in pacientes) {
      if (paciente.numHistoria == numGenerado) return true;
    }
    return false;
  }

  Future<bool> insertaPaciente(Paciente paciente) async {
    String? idGenerado = await PacientesProvider.postPaciente(paciente);

    if (idGenerado != null) {
      // Asigno el idGenerado al paciente
      paciente.idPaciente = idGenerado;
      return true;
    }
    return false;
  }

  Future<Consulta?> asignaPacienteConsulta(Paciente? paciente) async {
    if (paciente == null) return null;

    // Recorro las consultas y agrego al paciente a la que este vacia
    for (var consulta in consultas) {
      if (consulta.idPaciente == '') {
        // Asigno al paciente a la consulta vacia
        consulta.idPaciente = paciente.idPaciente;

        consulta.libre = false;

        // Actualizo la consulta
        int code = await ConsultasProvider.putConsulta(consulta);

        // En caso de fallo devuelvo null
        if (code != 200) {
          consulta.idPaciente = '';
          return null;
        }

        // Retorno la consulta
        return consulta;
      }
    }

    // Si no hay consultas disponibles devuelvo null
    return null;
  }

  bool consultaValidaParaLiberar(int numConsulta){
    Consulta consultaElegida = consultas[numConsulta - 1];
    if (consultaElegida.libre == true) return false;
    return true;
  }

  Paciente? liberaConsulta(int numConsulta){
    Consulta consultaElegida = consultas[numConsulta - 1];
    Paciente? pacienteCurado = buscaPacienteByID(consultaElegida.idPaciente);
    consultaElegida.idPaciente = '';
    consultaElegida.libre = true;
    if (pacienteCurado != null) pacienteCurado.fechaCurado = DateTime.now().toString();

  }

  Future<Paciente?> recuperaPaciente(Paciente paciente) async {
    return PacientesProvider.getPaciente(paciente);
  }
}
