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
    DateTime fechaCuracionConTiempo;
    DateTime fechaHoyConTiempo = DateTime.now();

    int cont = 0;

    // Recorro los pacientes
    for (var paciente in pacientes) {
      // Si el paciente ha sido curado
      if (paciente.fechaCurado != "") {
        // Parseo la fecha
        fechaCuracionConTiempo = DateTime.parse(
          paciente.fechaCurado.toString(),
        );

        // Fecha de curacion del paciente
        // Como es un dateTime, le quito horas, minutos y
        // segundos para quedarme con solo la fecha para comparar
        DateTime fechaCuracionSinTiempo = DateTime(
          fechaCuracionConTiempo.year,
          fechaCuracionConTiempo.month,
          fechaCuracionConTiempo.day,
        );

        // Fecha de hoy
        // De igual manera parseo la fecha de hoy
        DateTime fechaHoySinTiempo = DateTime(
          fechaHoyConTiempo.year,
          fechaHoyConTiempo.month,
          fechaHoyConTiempo.day,
        );

        if (fechaHoySinTiempo == fechaCuracionSinTiempo) cont++;
      }
    }

    return cont;
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

  Consulta? buscaConsultaByID(String? idConsultaPasada) {
    for (var consulta in consultas) {
      if (consulta.idConsulta == idConsultaPasada) return consulta;
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
          if (paciente.fechaCurado != '') cola.remove(paciente);
        }
      }
    }

    // Ordeno la lista por fecha de registro
    cola.sort((pacienteA, pacienteB) {
      // Extraigo la fecha parseada para compararla
      DateTime fechaPacienteA = DateTime.parse(
        pacienteA.fechaRegistro.toString(),
      );

      DateTime fechaPacienteB = DateTime.parse(
        pacienteB.fechaRegistro.toString(),
      );

      return fechaPacienteA.compareTo(fechaPacienteB);
    });

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

  Future<bool> liberaConsulta(int numConsulta) async {
    // Verifico si la consulta existe
    if ((numConsulta) > consultas.length || numConsulta <= 0) return false;

    // Me traigo la consulta elegida
    Consulta temp = consultas[numConsulta - 1];
    Consulta? consulta = buscaConsultaByID(temp.idConsulta);

    if (consulta == null) return false;

    // Me traigo el paciente de la consulta
    Paciente? pacienteCurado = buscaPacienteByID(consulta.idPaciente);
    if (pacienteCurado == null) return false;

    // Modifico los valores de la consulta
    consulta.idPaciente = '';
    consulta.libre = true;

    // Le asignno la fecha en la que ha sido curado
    pacienteCurado.fechaCurado = DateTime.now().toIso8601String();

    // Actualizo la consulta y el paciente
    int statusCodeConsulta = await ConsultasProvider.putConsulta(consulta);
    int statusCodePaciente = await PacientesProvider.putPaciente(
      pacienteCurado,
    );

    return statusCodeConsulta == 200 && statusCodePaciente == 200;
  }

  Future<Paciente?> asignaSiguientePacienteConsulta(
    Consulta consultaPasada,
  ) async {
    Consulta? consultaLiberada = buscaConsultaByID(consultaPasada.idConsulta);
    if (consultaLiberada == null) return null;

    if (getCola().isEmpty) return null;

    Paciente pacienteAAsignar = getCola().first;

    consultaLiberada.idPaciente = pacienteAAsignar.idPaciente;
    consultaLiberada.libre = false;

    ConsultasProvider.putConsulta(consultaLiberada);

    return pacienteAAsignar;
  }

  Medico? recuperaMedicoConsulta(Consulta consulta) {
    return buscaMedicoByID(consulta.idMedico);
  }

  Future<Paciente?> recuperaPaciente(Paciente paciente) async {
    return PacientesProvider.getPaciente(paciente);
  }
}
