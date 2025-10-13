class Medico {
  
  // Atributos
  int _id = -1;
  String _nombre = '';
  String _especialidad = '';

  //Getters y Setters
  int get id => _id;
  String get nombre => _nombre;
  String get especialidad => _especialidad;

  // Constructor
  Medico(int id, String nombre, String especialidad) {
    _id = id;
    _nombre = nombre;
    _especialidad = especialidad;
  }

  // toString
  @override
  String toString() {
    return 'Medico{_id: $_id, _nombre: $_nombre, _especialidad: $_especialidad}';
  }

}
