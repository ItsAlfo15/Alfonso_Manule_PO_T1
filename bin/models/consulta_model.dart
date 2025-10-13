import 'medico_model.dart';
import 'paciente_model.dart';

class Consulta {

  // Atributos
  Medico? _medico;
  Paciente? _paciente;
  bool _libre = true;

  //Getters y Setters
  Medico? get medico => _medico;
  Paciente? get paciente => _paciente;
  bool get libre => _libre;

  // Constructor
  Consulta(Medico medico, Paciente paciente, bool libre) {
    _medico = medico;
    _paciente = paciente;
    _libre = libre;
  }

  // toString
  @override
  String toString() {
    return 'Consulta{_medico: $_medico, _paciente: $_paciente, _libre: $_libre}';
  }

}
