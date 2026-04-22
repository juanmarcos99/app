import 'dart:math';

class IdGenerator {
  static final Random _random = Random();
  static int _lastId = 0;

  static int generate() {
    // 1. Obtenemos el tiempo en microsegundos (16 dígitos aprox)
    int timestamp = DateTime.now().microsecondsSinceEpoch;

    // 2. Generamos un número aleatorio entre 100 y 999 (3 dígitos)
    int randomPart = 100 + _random.nextInt(900);

    // 3. Combinamos: Multiplicamos el tiempo por 1000 para "hacer espacio" 
    // al final y sumamos el aleatorio.
    int finalId = (timestamp * 1000) + randomPart;

    // 4. Verificación de seguridad por si se genera en el mismo microsegundo
    if (finalId <= _lastId) {
      finalId = _lastId + 1;
    }

    _lastId = finalId;
    return finalId;
  }
}