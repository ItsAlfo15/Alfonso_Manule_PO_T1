import 'dart:async';
import 'dart:developer';

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
    medicos = await getMedicos();
    pacientes = await getPacientes();
    consultas = await getConsultas();
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

  bool insertaPaciente(String? dni, String? nombre, String? apellidos, String? sintomas){
    if (dni == null || nombre == null || apellidos == null || sintomas == null) return false;
    Paciente pacienteTemp = new Paciente(apellidos: apellidos, dni: dni, nombre: nombre, numHistoria: numHistoria, sintomas: sintomas)
  }

}