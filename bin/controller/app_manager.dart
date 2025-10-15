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

  // Getters y Setters

  getDatosControlador() async {
    medicos = await getMedicos();
    pacientes = await getPacientes();
    consultas = await getConsultas();
  }

  // Constructor
  AppManager();

  int numConsultas() {
    return consultas.length;
  }

  int numConsultasLibres() {
    int cont = 0;

    for (var consulta in consultas) 
    if (consulta.idPaciente == null) cont++;

    return cont;
  }

  int numPacientesEnCola() {
    return getCola().length;
  }

  int numPacientesCurados() {
    return -1;
  }

  Medico? buscaMedicoByID(String idMedicoPasado) {
    for (var medico in medicos)
      if (medico.idMedico == idMedicoPasado) return medico;
    return null;
  }

  Paciente? buscaPacienteByID(String idPacientePasado) {
    for (var paciente in pacientes)
      if (paciente.idPaciente == idPacientePasado) return paciente;
    return null;
  }

  List<Paciente> getCola() {
    List<Paciente> cola = List.from(pacientes);

    // Recorro las consultas
    for (var consula in consultas) {
      if (consula.idPaciente != null) {
        // Recorro los pacientes
        for (var paciente in pacientes) {
          if (consula.idPaciente == paciente.idPaciente) cola.remove(paciente);
        }
      }
    }

    return cola;
  }



}