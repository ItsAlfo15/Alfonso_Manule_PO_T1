import '../models/paciente_model.dart';
import '../models/medico_model.dart';
import '../models/consulta_model.dart';
import '../data/mock_Data.dart';

class AppManager {

  // Atributos
  List<Paciente> _pacientes = [];
  List<Medico> _medicos = [];
  List<Consulta> _consultas = [];

  // Getters y Setters
  List<Paciente> get pacientes => _pacientes;
  List<Medico> get medicos => _medicos;
  List<Consulta> get consultas => _consultas;
  
  // Constructor
  AppManager() {
    _pacientes = MockData.getPacientes();
    _medicos = MockData.getMedicos();
    _consultas = MockData.getConsultas();
  }

  





}