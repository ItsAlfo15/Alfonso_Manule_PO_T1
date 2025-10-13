import '../models/paciente_model.dart';


class MockData {
  // Devuelve lista de pacientes de ejemplo
  static List<Paciente> getPacientes() {
    return [
      Paciente(1, "12345678A", "Laura", "Martínez Pérez", "Dolor de cabeza"),
      Paciente(2, "87654321B", "Carlos", "Gómez López", "Fiebre y tos"),
      Paciente(3, "45678912C", "Ana", "Ruiz Fernández", "Dolor abdominal"),
    ];
  }

 

}
