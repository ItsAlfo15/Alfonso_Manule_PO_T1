class Paciente {
  // Atributos
  int _numHistoria = -1;
  String _dni = '';
  String _nombre = '';
  String _apellidos = '';
  String _sintomas = '';

  //Getters y Setters
  int get numHistoria => _numHistoria;
  String get dni => _dni;
  String get nombre => _nombre;
  String get apellidos => _apellidos;
  String get sintomas => _sintomas;

  // Constructor
  Paciente(int numHistoria, String dni, String nombre, String apellidos, String sintomas) {
    _numHistoria = numHistoria;
    _dni = dni;
    _nombre = nombre;
    _apellidos = apellidos;
    _sintomas = sintomas;
  }

  // toString
  @override
  String toString() {
    return 'Paciente{_numHistoria: $_numHistoria, _dni: $_dni, _nombre: $_nombre, _apellidos: $_apellidos, _sintomas: $_sintomas}';
  }
}
