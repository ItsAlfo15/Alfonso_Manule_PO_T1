import '../models/medico_model.dart';
import '../models/paciente_model.dart';
import '../models/consulta_model.dart';

class MockData {
  // Devuelve lista de pacientes de ejemplo
  static List<Paciente> getPacientes() {
    return [
      Paciente(1, "12345678A", "Laura", "Martínez Pérez", "Dolor de cabeza"),
      Paciente(2, "87654321B", "Carlos", "Gómez López", "Fiebre y tos"),
      Paciente(3, "45678912C", "Ana", "Ruiz Fernández", "Dolor abdominal"),
    ];
  }

  // Devuelve lista de médicos de ejemplo
  static List<Medico> getMedicos() {
    return [
      Medico(1, "Dr. Juan Torres", "Cardiología"),
      Medico(2, "Dra. Marta Sánchez", "Pediatría"),
      Medico(3, "Dr. Luis Fernández", "Neurología"),
    ];
  }

  // Devuelve lista de consultas de ejemplo
  static List<Consulta> getConsultas() {
    List<Paciente> pacientes = getPacientes();
    List<Medico> medicos = getMedicos();

    return [
      Consulta(medicos[0], pacientes[0], false),
      Consulta(medicos[1], pacientes[1], false),
      Consulta(medicos[2], pacientes[2], true),
    ];
  }
}
