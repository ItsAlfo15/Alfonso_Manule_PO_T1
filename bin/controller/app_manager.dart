import 'dart:async';

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

  getDatosControlador() async{
    medicos = await getMedicos();
    pacientes = await getPacientes();
    consultas = await getConsultas();
  }

  // Constructor
  AppManager() {
  
  }
}
