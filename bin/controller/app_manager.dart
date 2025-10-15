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
    consultas.forEach((consulta) {
      if (consulta.idPaciente == null) cont++;
    });
    return cont;
  }

  int numPacientesEnCola() {
    return -1;
  }

  int numPacientesCurados() {
    return -1;
  }

  Medico? buscaMedicoByID(String? idMedicoPasado) {
    Medico? temp;

    medicos.forEach((medico) {
      if (medico.idMedico == idMedicoPasado) temp = medico;
    });

    return temp;
  }

  Paciente? buscaPacienteByID(String? idPacientePasado) {
    Paciente? temp;

    pacientes.forEach((paciente) {
      if (paciente.idPaciente == idPacientePasado) temp = paciente;
    });

    return temp;
  }

  List<Paciente> getCola() {
    List<Paciente> cola =  List.from(pacientes);

    consultas.forEach((consulta) {
      if (consulta.idPaciente != null) {
        pacientes.forEach((paciente) {
          if (consulta.idPaciente == paciente.idPaciente) cola.remove(paciente);
        });
      }
    });

    return cola;
  }
}
